import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AppService {
  private apiUrl = '/api'; // Will be proxied to backend

  constructor(private http: HttpClient) { }

  getData(): Observable<any> {
    return this.http.get(`${this.apiUrl}/data`);
  }

  getStatus(): Observable<any> {
    return this.http.get(`${this.apiUrl}/status`);
  }

  postData(data: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/data`, data);
  }
}
