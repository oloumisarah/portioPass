const Firestore = require('@google-cloud/firestore');
const admin = require("firebase-admin");
const PROJECTID = 'portiopass';
const COLLECTION_NAME = 'users';
const firestore = new Firestore({
  projectId: PROJECTID,
  timestampsInSnapshots: true,
});

const FieldValue = admin.firestore.FieldValue;
const FieldPath = admin.firestore.FieldPath;

exports.main = (req, res) => {
  
  // Get a current Date
  var d = new Date();

  if (req.method === 'GET') {
    let collectionRef = firestore.collection(COLLECTION_NAME);
    return collectionRef.listDocuments().then(documentRefs => {
      for(let docRef of documentRefs) {
        console.log(docRef)
        docRef.get("Accounts").then(accounts => {
          if (accounts.exists) {
            console.log("accountffs: " + JSON.stringify(accounts.data()))

            // for every account the user has
            for(uid in accounts.data()["Accounts"]){
              console.log("uid: " + uid)
              var expDate = accounts.get("Accounts."+uid+".accountShareExpDate")
              var deleteAccount = false;
              if(expDate != null){
                var date = splitDate(expDate);
                if (date < d ){
                // account is expired .. delete the account
                console.log("Account Is Expired");
                deleteAccount = true
                }
              }
              if(deleteAccount == true){
                var account = "Accounts."+uid;
                console.log(account)
                let fpath = new FieldPath("Accounts." + uid);
                console.log("Path: " + fpath)
                docRef.update({
                  fpath: FieldValue.delete()
                }).then(res => {
                  console.log("Successfully Delete: " + res.writeTime)
                }).catch((err)=>{
                  console.log("Failed to delete: " + err)
                });
              }
            }
          }
        })
      }
      return res.status(200).send("Success");
      //return firestore.getAll(...documentRefs);
    })
 
}
}

function splitDate(dateString){
  newDate = dateString.replace(" ","T");
  date = new Date(newDate)
  return date;
}

