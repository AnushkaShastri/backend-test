import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import {NgbModal, ModalDismissReasons} from '@ng-bootstrap/ng-bootstrap';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'angular-frontend';
  isPing:boolean=false;
  isResponse:boolean=false;
  apiResponse:any={};
  closeResult = '';
   constructor(private http: HttpClient,private modalService: NgbModal) {
  }
  open(content: any) {
    this.modalService.open(content, {ariaLabelledBy: 'modal-basic-title'}).result.then((result: any) => {
      this.closeResult = `Closed with: ${result}`;
    }, (reason: any) => {
      this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
    });
  }
  private getDismissReason(reason: any): string {
    if (reason === ModalDismissReasons.ESC) {
      return 'by pressing ESC';
    } else if (reason === ModalDismissReasons.BACKDROP_CLICK) {
      return 'by clicking on a backdrop';
    } else {
      return `with: ${reason}`;
    }
  }
  ping()
  {   this.isPing=true;
    this.http.get(environment.PING_API).subscribe(
       (data)=>{
         console.log(data);
         this.apiResponse=JSON.stringify(data);
         this.isResponse=true;
         console.log(this.apiResponse);
         this.isPing=false;
       }
  )
  
  
    
  }
}
