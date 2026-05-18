import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { AppService } from './app.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Angular Kubernetes App';
  backendData: any = null;
  loading = false;
  error: string | null = null;

  constructor(private appService: AppService) {}

  ngOnInit() {
    this.fetchData();
  }

  fetchData() {
    this.loading = true;
    this.error = null;
    this.appService.getData().subscribe({
      next: (data) => {
        this.backendData = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Failed to fetch data from backend: ' + err.message;
        this.loading = false;
        console.error('Error:', err);
      }
    });
  }
}
