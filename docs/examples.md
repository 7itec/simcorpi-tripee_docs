# Exemplos de Código

Esta seção fornece exemplos práticos de integração com a API Tripee em diferentes linguagens e frameworks.

## 📑 Índice

- [JavaScript/TypeScript](#javascripttypescript)
  - [React](#react)
  - [Vue.js](#vuejs)
  - [Node.js](#nodejs)
- [Python](#python)
- [cURL](#curl)

---

## JavaScript/TypeScript

### React

#### Serviço de API Completo

```typescript
// src/services/tripeeApi.ts
import axios, { AxiosInstance } from 'axios';

interface AuthTokens {
  access_token: string;
  refresh_token: string;
}

interface User {
  _id: string;
  name: string;
  email: string;
  registrationNumber: number;
}

interface TripeeAuthResponse {
  access_token: string;
  refresh_token: string;
  user: User;
}

class TripeeApiService {
  private api: AxiosInstance;
  private baseURL = 'https://api.example.com/tripee';
  private accessToken: string | null = null;
  private refreshToken: string | null = null;

  constructor() {
    this.api = axios.create({
      baseURL: this.baseURL,
    });

    // Interceptor para adicionar token automaticamente
    this.api.interceptors.request.use(
      (config) => {
        if (this.accessToken) {
          config.headers.Authorization = `Bearer ${this.accessToken}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // Interceptor para renovar token em caso de 401
    this.api.interceptors.response.use(
      (response) => response,
      async (error) => {
        const originalRequest = error.config;

        if (error.response?.status === 401 && !originalRequest._retry) {
          originalRequest._retry = true;

          try {
            await this.refreshAccessToken();
            return this.api(originalRequest);
          } catch (refreshError) {
            // Redirecionar para login
            this.logout();
            window.location.href = '/login';
            return Promise.reject(refreshError);
          }
        }

        return Promise.reject(error);
      }
    );

    // Carregar tokens do localStorage
    this.loadTokens();
  }

  private loadTokens() {
    this.accessToken = localStorage.getItem('tripee_access_token');
    this.refreshToken = localStorage.getItem('tripee_refresh_token');
  }

  private saveTokens(tokens: AuthTokens) {
    this.accessToken = tokens.access_token;
    this.refreshToken = tokens.refresh_token;
    localStorage.setItem('tripee_access_token', tokens.access_token);
    localStorage.setItem('tripee_refresh_token', tokens.refresh_token);
  }

  private clearTokens() {
    this.accessToken = null;
    this.refreshToken = null;
    localStorage.removeItem('tripee_access_token');
    localStorage.removeItem('tripee_refresh_token');
  }

  // Autenticação via Azure AD
  async authenticateWithAzureAD(azureToken: string): Promise<TripeeAuthResponse> {
    const response = await axios.post<TripeeAuthResponse>(
      `${this.baseURL}/auth/sso`,
      {},
      {
        headers: {
          Authorization: `Bearer ${azureToken}`,
        },
      }
    );

    this.saveTokens({
      access_token: response.data.access_token,
      refresh_token: response.data.refresh_token,
    });

    return response.data;
  }

  // Renovar token
  async refreshAccessToken(): Promise<void> {
    if (!this.refreshToken) {
      throw new Error('No refresh token available');
    }

    const response = await axios.post<AuthTokens>(
      `${this.baseURL}/auth/refresh`,
      {},
      {
        headers: {
          Authorization: `Bearer ${this.refreshToken}`,
        },
      }
    );

    this.saveTokens(response.data);
  }

  // Logout
  async logout(): Promise<void> {
    if (this.refreshToken) {
      try {
        await axios.post(
          `${this.baseURL}/auth/logout`,
          {},
          {
            headers: {
              Authorization: `Bearer ${this.refreshToken}`,
              'origin-platform': 'Web',
            },
          }
        );
      } catch (error) {
        console.error('Logout error:', error);
      }
    }

    this.clearTokens();
  }

  // Buscar centros de planejamento
  async getPlanningCenters() {
    const response = await this.api.get('/planning-centers/all');
    return response.data;
  }

  // Buscar modes de um centro de planejamento
  async getPlanningCenterModes(planningCenterId: string) {
    const response = await this.api.get(`/planning-centers/${planningCenterId}/modes`);
    return response.data;
  }

  // Buscar centro de custo
  async getCostCenterByName(name: string) {
    const response = await this.api.get(`/cost-centers/names/${name}`);
    return response.data;
  }

  // Criar solicitação de transporte
  async createTrip(tripData: any, files?: File[]) {
    const formData = new FormData();
    
    // Calcular timezone offset do navegador
    const timezoneOffset = this.getTimezoneOffset();
    
    formData.append('data', JSON.stringify(tripData));
    
    if (files && files.length > 0) {
      files.forEach((file) => {
        formData.append('files', file);
      });
    }

    const response = await this.api.post('/trips/personnel', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        'timezone-offset': timezoneOffset,
      },
    });

    return response.data;
  }

  // Atualizar solicitação de transporte
  async updateTrip(tripId: string, tripData: any, files?: File[]) {
    const formData = new FormData();
    const timezoneOffset = this.getTimezoneOffset();
    
    formData.append('data', JSON.stringify(tripData));
    
    if (files && files.length > 0) {
      files.forEach((file) => {
        formData.append('files', file);
      });
    }

    const response = await this.api.patch(`/trips/${tripId}`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        'timezone-offset': timezoneOffset,
      },
    });

    return response.data;
  }

  // Listar viagens
  async getTrips(filters: any) {
    const response = await this.api.get('/trips/personnel', {
      params: filters,
    });
    return response.data;
  }

  // Buscar viagem por ID
  async getTripById(tripId: string) {
    const response = await this.api.get(`/trips/${tripId}`);
    return response.data;
  }

  // Cancelar viagem
  async cancelTrip(tripId: string) {
    const response = await this.api.patch(`/trips/${tripId}/cancel`);
    return response.data;
  }

  // Utilitário: obter timezone offset do navegador
  private getTimezoneOffset(): string {
    const offset = -new Date().getTimezoneOffset();
    const hours = Math.floor(Math.abs(offset) / 60);
    const minutes = Math.abs(offset) % 60;
    const sign = offset >= 0 ? '+' : '-';
    
    return `${sign}${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
  }

  // Verificar se está autenticado
  isAuthenticated(): boolean {
    return !!this.accessToken;
  }
}

export const tripeeApi = new TripeeApiService();
```

#### Hook React Customizado

```typescript
// src/hooks/useTripeeApi.ts
import { useState, useCallback } from 'react';
import { tripeeApi } from '../services/tripeeApi';

export function useTripeeApi() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const execute = useCallback(async <T,>(
    apiCall: () => Promise<T>
  ): Promise<T | null> => {
    setLoading(true);
    setError(null);

    try {
      const result = await apiCall();
      return result;
    } catch (err: any) {
      const errorMessage = err.response?.data?.message || err.message || 'An error occurred';
      setError(errorMessage);
      return null;
    } finally {
      setLoading(false);
    }
  }, []);

  return { loading, error, execute };
}
```

#### Componente de Criação de Viagem

```typescript
// src/components/CreateTripForm.tsx
import React, { useState, useEffect } from 'react';
import { tripeeApi } from '../services/tripeeApi';
import { useTripeeApi } from '../hooks/useTripeeApi';

interface PlanningCenter {
  _id: string;
  name: string;
}

interface Mode {
  _id: string;
  name: string;
}

export function CreateTripForm() {
  const { loading, error, execute } = useTripeeApi();
  
  const [planningCenters, setPlanningCenters] = useState<PlanningCenter[]>([]);
  const [modes, setModes] = useState<Mode[]>([]);
  const [selectedPlanningCenter, setSelectedPlanningCenter] = useState('');
  const [selectedMode, setSelectedMode] = useState('');
  const [requestedFor, setRequestedFor] = useState('');
  const [observations, setObservations] = useState('');
  const [files, setFiles] = useState<File[]>([]);
  
  // Dados do passageiro
  const [passengerName, setPassengerName] = useState('');
  const [passengerEmail, setPassengerEmail] = useState('');
  const [passengerPhone, setPassengerPhone] = useState('');
  const [registrationNumber, setRegistrationNumber] = useState('');
  const [department, setDepartment] = useState('');
  const [costCenter, setCostCenter] = useState('');

  // Carregar centros de planejamento ao montar
  useEffect(() => {
    loadPlanningCenters();
  }, []);

  // Carregar modes quando centro for selecionado
  useEffect(() => {
    if (selectedPlanningCenter) {
      loadModes(selectedPlanningCenter);
    }
  }, [selectedPlanningCenter]);

  const loadPlanningCenters = async () => {
    const result = await execute(() => tripeeApi.getPlanningCenters());
    if (result) {
      setPlanningCenters(result);
    }
  };

  const loadModes = async (planningCenterId: string) => {
    const result = await execute(() => 
      tripeeApi.getPlanningCenterModes(planningCenterId)
    );
    if (result) {
      setModes(result);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      const selectedFiles = Array.from(e.target.files);
      
      // Validar quantidade
      if (selectedFiles.length > 3) {
        alert('Máximo de 3 arquivos permitidos');
        return;
      }
      
      // Validar tamanho
      const maxSize = 5 * 1024 * 1024; // 5MB
      const invalidFiles = selectedFiles.filter(file => file.size > maxSize);
      if (invalidFiles.length > 0) {
        alert('Cada arquivo deve ter no máximo 5MB');
        return;
      }
      
      setFiles(selectedFiles);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Validações
    if (!selectedPlanningCenter || !selectedMode || !requestedFor) {
      alert('Preencha todos os campos obrigatórios');
      return;
    }

    // Montar dados da viagem
    const tripData = {
      mode: modes.find(m => m._id === selectedMode)?.name,
      planningCenter: planningCenters.find(pc => pc._id === selectedPlanningCenter)?.name,
      requestedFor: new Date(requestedFor).toISOString(),
      requestUserTimezone: getTimezoneOffset(),
      observations: observations || undefined,
      tripulation: [
        {
          name: passengerName,
          email: passengerEmail,
          phone: passengerPhone,
          registrationNumber: parseInt(registrationNumber),
          department,
          costCenter: [costCenter],
          isVip: false,
          pcd: false,
          originAddress: {
            street: 'RUA EXEMPLO',
            streetNumber: '123',
            neighborhood: 'CENTRO',
            city: 'SÃO PAULO',
            state: 'SÃO PAULO',
            uf: 'SP',
            zipcode: '01000-000',
            latitude: -23.550520,
            longitude: -46.633308,
          },
          destinyAddress: {
            street: 'AVENIDA EXEMPLO',
            streetNumber: '456',
            neighborhood: 'JARDINS',
            city: 'SÃO PAULO',
            state: 'SÃO PAULO',
            uf: 'SP',
            zipcode: '01400-000',
            latitude: -23.561414,
            longitude: -46.656130,
          },
        },
      ],
    };

    const result = await execute(() => 
      tripeeApi.createTrip(tripData, files)
    );

    if (result) {
      alert('Viagem criada com sucesso!');
      // Limpar formulário ou redirecionar
    }
  };

  const getTimezoneOffset = (): string => {
    const offset = -new Date().getTimezoneOffset();
    const hours = Math.floor(Math.abs(offset) / 60);
    const minutes = Math.abs(offset) % 60;
    const sign = offset >= 0 ? '+' : '-';
    return `${sign}${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <h2 className="text-2xl font-bold">Criar Solicitação de Transporte</h2>

      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
          {error}
        </div>
      )}

      {/* Centro de Planejamento */}
      <div>
        <label className="block mb-2">Centro de Planejamento *</label>
        <select
          value={selectedPlanningCenter}
          onChange={(e) => setSelectedPlanningCenter(e.target.value)}
          className="w-full border rounded px-3 py-2"
          required
        >
          <option value="">Selecione...</option>
          {planningCenters.map((pc) => (
            <option key={pc._id} value={pc._id}>
              {pc.name}
            </option>
          ))}
        </select>
      </div>

      {/* Tipo de Viagem */}
      <div>
        <label className="block mb-2">Tipo de Viagem *</label>
        <select
          value={selectedMode}
          onChange={(e) => setSelectedMode(e.target.value)}
          className="w-full border rounded px-3 py-2"
          required
          disabled={!selectedPlanningCenter}
        >
          <option value="">Selecione...</option>
          {modes.map((mode) => (
            <option key={mode._id} value={mode._id}>
              {mode.name}
            </option>
          ))}
        </select>
      </div>

      {/* Data da Viagem */}
      <div>
        <label className="block mb-2">Data e Hora da Viagem *</label>
        <input
          type="datetime-local"
          value={requestedFor}
          onChange={(e) => setRequestedFor(e.target.value)}
          className="w-full border rounded px-3 py-2"
          required
        />
      </div>

      {/* Dados do Passageiro */}
      <fieldset className="border rounded p-4">
        <legend className="font-semibold">Dados do Passageiro</legend>
        
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block mb-2">Nome *</label>
            <input
              type="text"
              value={passengerName}
              onChange={(e) => setPassengerName(e.target.value)}
              className="w-full border rounded px-3 py-2"
              required
            />
          </div>

          <div>
            <label className="block mb-2">Email *</label>
            <input
              type="email"
              value={passengerEmail}
              onChange={(e) => setPassengerEmail(e.target.value)}
              className="w-full border rounded px-3 py-2"
              required
            />
          </div>

          <div>
            <label className="block mb-2">Telefone *</label>
            <input
              type="tel"
              value={passengerPhone}
              onChange={(e) => setPassengerPhone(e.target.value)}
              className="w-full border rounded px-3 py-2"
              required
            />
          </div>

          <div>
            <label className="block mb-2">Matrícula *</label>
            <input
              type="number"
              value={registrationNumber}
              onChange={(e) => setRegistrationNumber(e.target.value)}
              className="w-full border rounded px-3 py-2"
              required
            />
          </div>

          <div>
            <label className="block mb-2">Departamento *</label>
            <input
              type="text"
              value={department}
              onChange={(e) => setDepartment(e.target.value)}
              className="w-full border rounded px-3 py-2"
              required
            />
          </div>

          <div>
            <label className="block mb-2">Centro de Custo *</label>
            <input
              type="text"
              value={costCenter}
              onChange={(e) => setCostCenter(e.target.value)}
              className="w-full border rounded px-3 py-2"
              placeholder="Ex: A003ADMR01"
              required
            />
          </div>
        </div>
      </fieldset>

      {/* Observações */}
      <div>
        <label className="block mb-2">Observações</label>
        <textarea
          value={observations}
          onChange={(e) => setObservations(e.target.value)}
          className="w-full border rounded px-3 py-2"
          rows={3}
        />
      </div>

      {/* Anexos */}
      <div>
        <label className="block mb-2">Anexos (máx 3, até 5MB cada)</label>
        <input
          type="file"
          multiple
          accept="image/*,.pdf"
          onChange={handleFileChange}
          className="w-full"
        />
        {files.length > 0 && (
          <div className="mt-2">
            {files.map((file, index) => (
              <div key={index} className="text-sm text-gray-600">
                {file.name} ({(file.size / 1024 / 1024).toFixed(2)} MB)
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Botão Submit */}
      <button
        type="submit"
        disabled={loading}
        className="w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 disabled:bg-gray-400"
      >
        {loading ? 'Criando...' : 'Criar Solicitação'}
      </button>
    </form>
  );
}
```

---

### Vue.js

#### Composable para API

```typescript
// src/composables/useTripeeApi.ts
import { ref } from 'vue';
import axios from 'axios';

const baseURL = 'https://api.example.com/tripee';
const accessToken = ref<string | null>(localStorage.getItem('tripee_access_token'));
const refreshToken = ref<string | null>(localStorage.getItem('tripee_refresh_token'));

const api = axios.create({ baseURL });

// Interceptor para adicionar token
api.interceptors.request.use((config) => {
  if (accessToken.value) {
    config.headers.Authorization = `Bearer ${accessToken.value}`;
  }
  return config;
});

export function useTripeeApi() {
  const loading = ref(false);
  const error = ref<string | null>(null);

  const setTokens = (tokens: { access_token: string; refresh_token: string }) => {
    accessToken.value = tokens.access_token;
    refreshToken.value = tokens.refresh_token;
    localStorage.setItem('tripee_access_token', tokens.access_token);
    localStorage.setItem('tripee_refresh_token', tokens.refresh_token);
  };

  const authenticateWithAzureAD = async (azureToken: string) => {
    loading.value = true;
    error.value = null;

    try {
      const response = await axios.post(`${baseURL}/auth/sso`, {}, {
        headers: { Authorization: `Bearer ${azureToken}` },
      });
      setTokens(response.data);
      return response.data;
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Authentication failed';
      throw err;
    } finally {
      loading.value = false;
    }
  };

  const getPlanningCenters = async () => {
    loading.value = true;
    error.value = null;

    try {
      const response = await api.get('/planning-centers/all');
      return response.data;
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Failed to fetch planning centers';
      throw err;
    } finally {
      loading.value = false;
    }
  };

  const createTrip = async (tripData: any, files?: File[]) => {
    loading.value = true;
    error.value = null;

    try {
      const formData = new FormData();
      formData.append('data', JSON.stringify(tripData));

      if (files) {
        files.forEach((file) => formData.append('files', file));
      }

      const timezoneOffset = getTimezoneOffset();
      const response = await api.post('/trips/personnel', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          'timezone-offset': timezoneOffset,
        },
      });

      return response.data;
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Failed to create trip';
      throw err;
    } finally {
      loading.value = false;
    }
  };

  const getTimezoneOffset = (): string => {
    const offset = -new Date().getTimezoneOffset();
    const hours = Math.floor(Math.abs(offset) / 60);
    const minutes = Math.abs(offset) % 60;
    const sign = offset >= 0 ? '+' : '-';
    return `${sign}${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
  };

  return {
    loading,
    error,
    authenticateWithAzureAD,
    getPlanningCenters,
    createTrip,
  };
}
```

---

### Node.js

```typescript
// src/tripeeClient.ts
import axios, { AxiosInstance } from 'axios';
import * as FormData from 'form-data';
import * as fs from 'fs';

export class TripeeClient {
  private api: AxiosInstance;
  private accessToken: string | null = null;
  private refreshToken: string | null = null;

  constructor(baseURL: string = 'https://api.example.com/tripee') {
    this.api = axios.create({ baseURL });

    this.api.interceptors.request.use((config) => {
      if (this.accessToken) {
        config.headers.Authorization = `Bearer ${this.accessToken}`;
      }
      return config;
    });
  }

  async authenticateWithAzureAD(azureToken: string) {
    const response = await axios.post(
      `${this.api.defaults.baseURL}/auth/sso`,
      {},
      {
        headers: { Authorization: `Bearer ${azureToken}` },
      }
    );

    this.accessToken = response.data.access_token;
    this.refreshToken = response.data.refresh_token;

    return response.data;
  }

  async createTrip(tripData: any, filePaths?: string[]) {
    const formData = new FormData();
    formData.append('data', JSON.stringify(tripData));

    if (filePaths) {
      filePaths.forEach((filePath) => {
        formData.append('files', fs.createReadStream(filePath));
      });
    }

    const timezoneOffset = this.getTimezoneOffset();
    const response = await this.api.post('/trips/personnel', formData, {
      headers: {
        ...formData.getHeaders(),
        'timezone-offset': timezoneOffset,
      },
    });

    return response.data;
  }

  private getTimezoneOffset(): string {
    const offset = -new Date().getTimezoneOffset();
    const hours = Math.floor(Math.abs(offset) / 60);
    const minutes = Math.abs(offset) % 60;
    const sign = offset >= 0 ? '+' : '-';
    return `${sign}${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
  }
}

// Uso
const client = new TripeeClient();
await client.authenticateWithAzureAD('azure-token');
const trip = await client.createTrip(tripData, ['./document.pdf']);
```

---

## Python

```python
# tripee_client.py
import requests
from datetime import datetime, timezone
from typing import List, Optional, Dict, Any
import json

class TripeeClient:
    def __init__(self, base_url: str = "https://api.example.com/tripee"):
        self.base_url = base_url
        self.access_token: Optional[str] = None
        self.refresh_token: Optional[str] = None
        self.session = requests.Session()
    
    def _get_headers(self) -> Dict[str, str]:
        headers = {"Content-Type": "application/json"}
        if self.access_token:
            headers["Authorization"] = f"Bearer {self.access_token}"
        return headers
    
    def _get_timezone_offset(self) -> str:
        """Calcula o offset do timezone local"""
        offset_seconds = -datetime.now(timezone.utc).astimezone().utcoffset().total_seconds()
        offset_hours = int(offset_seconds // 3600)
        offset_minutes = int((abs(offset_seconds) % 3600) // 60)
        sign = '+' if offset_hours >= 0 else '-'
        return f"{sign}{abs(offset_hours):02d}:{offset_minutes:02d}"
    
    def authenticate_with_azure_ad(self, azure_token: str) -> Dict[str, Any]:
        """Autentica usando token do Azure AD"""
        response = requests.post(
            f"{self.base_url}/auth/sso",
            headers={"Authorization": f"Bearer {azure_token}"}
        )
        response.raise_for_status()
        
        data = response.json()
        self.access_token = data["access_token"]
        self.refresh_token = data["refresh_token"]
        
        return data
    
    def refresh_access_token(self) -> None:
        """Renova o access token"""
        if not self.refresh_token:
            raise ValueError("No refresh token available")
        
        response = requests.post(
            f"{self.base_url}/auth/refresh",
            headers={"Authorization": f"Bearer {self.refresh_token}"}
        )
        response.raise_for_status()
        
        data = response.json()
        self.access_token = data["access_token"]
        self.refresh_token = data["refresh_token"]
    
    def get_planning_centers(self) -> List[Dict[str, Any]]:
        """Busca todos os centros de planejamento"""
        response = self.session.get(
            f"{self.base_url}/planning-centers/all",
            headers=self._get_headers()
        )
        response.raise_for_status()
        return response.json()
    
    def get_planning_center_modes(self, planning_center_id: str) -> List[Dict[str, Any]]:
        """Busca os modes de um centro de planejamento"""
        response = self.session.get(
            f"{self.base_url}/planning-centers/{planning_center_id}/modes",
            headers=self._get_headers()
        )
        response.raise_for_status()
        return response.json()
    
    def create_trip(
        self, 
        trip_data: Dict[str, Any], 
        files: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """Cria uma nova solicitação de transporte"""
        
        # Preparar FormData
        files_data = []
        if files:
            for file_path in files:
                files_data.append(
                    ('files', (file_path.split('/')[-1], open(file_path, 'rb')))
                )
        
        # Preparar dados
        data = {
            'data': json.dumps(trip_data)
        }
        
        # Headers
        headers = {"Authorization": f"Bearer {self.access_token}"}
        headers["timezone-offset"] = self._get_timezone_offset()
        
        response = self.session.post(
            f"{self.base_url}/trips/personnel",
            data=data,
            files=files_data,
            headers=headers
        )
        response.raise_for_status()
        
        # Fechar arquivos
        for _, file_tuple in files_data:
            file_tuple[1].close()
        
        return response.json()
    
    def get_trips(self, filters: Dict[str, Any]) -> Dict[str, Any]:
        """Lista viagens com filtros"""
        response = self.session.get(
            f"{self.base_url}/trips/personnel",
            params=filters,
            headers=self._get_headers()
        )
        response.raise_for_status()
        return response.json()
    
    def cancel_trip(self, trip_id: str) -> Dict[str, Any]:
        """Cancela uma viagem"""
        response = self.session.patch(
            f"{self.base_url}/trips/{trip_id}/cancel",
            headers=self._get_headers()
        )
        response.raise_for_status()
        return response.json()


# Exemplo de uso
if __name__ == "__main__":
    client = TripeeClient()
    
    # Autenticar
    client.authenticate_with_azure_ad("azure-token-here")
    
    # Buscar centros de planejamento
    planning_centers = client.get_planning_centers()
    print(f"Centros disponíveis: {planning_centers}")
    
    # Criar viagem
    trip_data = {
        "mode": "Requisição de Transporte",
        "planningCenter": "REPLAN",
        "requestedFor": datetime.now(timezone.utc).isoformat(),
        "requestUserTimezone": "-03:00",
        "observations": "Reunião importante",
        "tripulation": [
            {
                "name": "João Silva",
                "email": "joao@empresa.com",
                "phone": "11999999999",
                "registrationNumber": 123456,
                "department": "TI",
                "costCenter": ["A003ADMR01"],
                "isVip": False,
                "pcd": False,
                "originAddress": {
                    "street": "Rua A",
                    "streetNumber": "123",
                    "neighborhood": "Centro",
                    "city": "São Paulo",
                    "state": "São Paulo",
                    "uf": "SP",
                    "zipcode": "01000-000",
                    "latitude": -23.550520,
                    "longitude": -46.633308
                },
                "destinyAddress": {
                    "street": "Av B",
                    "streetNumber": "456",
                    "neighborhood": "Jardins",
                    "city": "São Paulo",
                    "state": "São Paulo",
                    "uf": "SP",
                    "zipcode": "01400-000",
                    "latitude": -23.561414,
                    "longitude": -46.656130
                }
            }
        ]
    }
    
    result = client.create_trip(trip_data, files=["./document.pdf"])
    print(f"Viagem criada: {result}")
```

---

## cURL

### Autenticação

```bash
# SSO com Azure AD
curl -X POST https://api.example.com/tripee/auth/sso \
  -H "Authorization: Bearer YOUR_AZURE_AD_TOKEN" \
  -H "Content-Type: application/json"

# Refresh Token
curl -X POST https://api.example.com/tripee/auth/refresh \
  -H "Authorization: Bearer YOUR_REFRESH_TOKEN" \
  -H "Content-Type: application/json"

# Logout
curl -X POST https://api.example.com/tripee/auth/logout \
  -H "Authorization: Bearer YOUR_REFRESH_TOKEN" \
  -H "origin-platform: Web" \
  -H "Content-Type: application/json"
```

### Criar Viagem Completa

```bash
curl -X POST https://api.example.com/tripee/trips/personnel \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "timezone-offset: -03:00" \
  -F 'data={
    "mode": "Requisição de Transporte",
    "planningCenter": "REPLAN",
    "requestedFor": "2024-04-25T14:30:00.000Z",
    "requestUserTimezone": "-03:00",
    "observations": "Reunião importante",
    "tripulation": [{
      "name": "João Silva",
      "email": "joao@empresa.com",
      "phone": "11999999999",
      "registrationNumber": 123456,
      "department": "TI",
      "costCenter": ["A003ADMR01"],
      "isVip": false,
      "pcd": false,
      "originAddress": {
        "street": "Rua A",
        "streetNumber": "123",
        "neighborhood": "Centro",
        "city": "São Paulo",
        "state": "São Paulo",
        "uf": "SP",
        "zipcode": "01000-000",
        "latitude": -23.550520,
        "longitude": -46.633308
      },
      "destinyAddress": {
        "street": "Av B",
        "streetNumber": "456",
        "neighborhood": "Jardins",
        "city": "São Paulo",
        "state": "São Paulo",
        "uf": "SP",
        "zipcode": "01400-000",
        "latitude": -23.561414,
        "longitude": -46.656130
      }
    }]
  }' \
  -F 'files=@./document1.pdf' \
  -F 'files=@./image1.jpg'
```

---

**Anterior:** [← Criação de Solicitações](trip-creation.md)
