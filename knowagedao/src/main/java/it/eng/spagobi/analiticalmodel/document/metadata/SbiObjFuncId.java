/*
 * Knowage, Open Source Business Intelligence suite
 * Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.
 * 
 * Knowage is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Knowage is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package it.eng.spagobi.analiticalmodel.document.metadata;

import it.eng.spagobi.analiticalmodel.functionalitytree.metadata.SbiFunctions;




/**
 * SbiObjFuncId generated by hbm2java
 */
public class SbiObjFuncId  implements java.io.Serializable {

    // Fields    

     private SbiFunctions sbiFunctions;
     private SbiObjects sbiObjects;


    // Constructors

    /**
     * default constructor.
     */
    public SbiObjFuncId() {
    }
    
   
    
    

    // Property accessors

    /**
     * Gets the sbi functions.
     * 
     * @return the sbi functions
     */
    public SbiFunctions getSbiFunctions() {
        return this.sbiFunctions;
    }
    
    /**
     * Sets the sbi functions.
     * 
     * @param sbiFunctions the new sbi functions
     */
    public void setSbiFunctions(SbiFunctions sbiFunctions) {
        this.sbiFunctions = sbiFunctions;
    }

    /**
     * Gets the sbi objects.
     * 
     * @return the sbi objects
     */
    public SbiObjects getSbiObjects() {
        return this.sbiObjects;
    }
    
    /**
     * Sets the sbi objects.
     * 
     * @param sbiObjects the new sbi objects
     */
    public void setSbiObjects(SbiObjects sbiObjects) {
        this.sbiObjects = sbiObjects;
    }

   /* (non-Javadoc)
    * @see java.lang.Object#equals(java.lang.Object)
    */
   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof SbiObjFuncId) ) return false;
		 SbiObjFuncId castOther = ( SbiObjFuncId ) other; 
         
		 return (this.getSbiFunctions()==castOther.getSbiFunctions()) || ( this.getSbiFunctions()!=null && castOther.getSbiFunctions()!=null && this.getSbiFunctions().equals(castOther.getSbiFunctions()) )
 && (this.getSbiObjects()==castOther.getSbiObjects()) || ( this.getSbiObjects()!=null && castOther.getSbiObjects()!=null && this.getSbiObjects().equals(castOther.getSbiObjects()) );
   }
   
   /* (non-Javadoc)
    * @see java.lang.Object#hashCode()
    */
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getSbiFunctions().hashCode();
         result = 37 * result + this.getSbiObjects().hashCode();
         return result;
   }   


}