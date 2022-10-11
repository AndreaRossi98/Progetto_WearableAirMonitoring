package com.example.respirho;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.RemoteException;
import android.os.SystemClock;
import android.os.Vibrator;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewStub;
import android.widget.Button;
import android.widget.Chronometer;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;    //aggiunto da environmental

import com.dsi.ant.AntService;
import com.dsi.ant.channel.AntChannel;
import com.dsi.ant.channel.AntChannelProvider;
import com.dsi.ant.channel.AntCommandFailedException;
import com.dsi.ant.channel.ChannelNotAvailableException;
import com.dsi.ant.channel.IAntChannelEventHandler;
import com.dsi.ant.channel.PredefinedNetwork;
import com.dsi.ant.message.AntMessage;
import com.dsi.ant.message.ChannelId;
import com.dsi.ant.message.ChannelType;
import com.dsi.ant.message.fromant.BroadcastDataMessage;
import com.dsi.ant.message.fromant.ChannelEventMessage;
import com.dsi.ant.message.fromant.MessageFromAntType;
import com.dsi.ant.message.ipc.AntMessageParcel;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.storage.FileDownloadTask;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.ListResult;
import com.google.firebase.storage.OnProgressListener;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.StorageTask;
import com.google.firebase.storage.UploadTask;

import org.jetbrains.annotations.NotNull;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import java.io.FileInputStream;         //importati da environmental
import java.io.FileNotFoundException;   //importati da environmental
import java.io.InputStreamReader;       //importati da environmental
import java.util.List;                  //importati da environmental

//IMPORT FOR POSITION
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.util.ArrayUtils;
import com.google.android.gms.location.ActivityRecognition;
import com.google.android.gms.location.ActivityRecognitionResult;
import com.google.android.gms.location.DetectedActivity;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.tasks.Task;

import android.location.Location;

public class IMUs_Saturation_Environmental extends AppCompatActivity implements View.OnClickListener {

    private Button timerrecordingbutton,manualrecordingbutton,initializationbutton,gotoswitchonsensors,gotorecordingbutton;
    private Button startrecording_manual,stoprecording_manual,downloadfile_manual,gotonewrecording_manual,goback_manual,showvaluesonmaps_manual;
    private Button startrecording_timer,stoprecording_timer,downloadfile_timer,gotonewrecording_timer,goback_timer,showvaluesonmaps_timer;
    private Button endcalibration_button;
    private ImageButton initialization_checkmark,
            switchonsensor1_checkmark,switchonsensor2_checkmark,switchonsensor3_checkmark, switchonsensor4_checkmark, switchonsensor6_checkmark;

    private ProgressBar progressBar_manual, progressBar_timer,progressbar_initialization,
            switchonsensor1_progressbar,switchonsensor2_progressbar,switchonsensor3_progressbar,switchonsensor4_progressbar,switchonsensor6_progressbar,progressbar_idpatient;
    private TextView status_manual,status_timer,status_initialization,bottom_initialization,
            switchonsensor1,switchonsensor2,switchonsensor3,switchonsensor4,switchonsensor6,manual_recording_filename,timer_recording_filename;
    private TextView timer;
    private TextView clickhereforcalibration;
    private TextInputLayout layout_insert_setduration, layout_insert_setinforec;
    private TextInputEditText insert_setduration, insert_setinforec;
    private CountDownTimer countDownTimer;
    private Chronometer chronometer;
    private ViewStub viewStub;
    private View inflated_initialization,inflated_switch_on_sensors,inflated_select_recording,inflated_calibration,inflated_manual_rec,inflated_timer_rec,inflated_updateinfo, inflated_displaydata;

    //PER STAMPARE A SCHERMO
    private TextView temperature_output;
    private TextView humidity_output;
    private TextView pressure_output;
    private TextView CO2_output;
    private TextView VOC_output;
    private TextView NO2_output;
    private TextView CO_output;
    private TextView PM1p0_output;
    private TextView PM2p5_output;
    private TextView PM10_output;

    //update info recording
    private RadioGroup posture_buttons;
    private RadioButton posture_selected;
    private TextInputLayout layout_insert_addinforec;
    private TextInputEditText insert_addinforec;
    private TextView inforecording;
    private Button updateinfo;
    private String posture= "None";
    private String oldposture = "None";

    //demo download layout
    private TextView id_patient,info_patient;
    private ImageButton telephone, storage,error_idpatient, exclamation_point_idpatient, checkmark_idpatient;
    private ImageView lowbattery_idpatient;
    private Button helpbutton;

    //STORAGE variables
    private StorageReference mStorageRef;
    //recycler view for storage from firebase storage
    public ArrayList<Item_StorageFiles> item_storage_files=null;
    private RecyclerView recyclerview_storage_files;
    private Adapter_PatientData adapter_storage_files;
    private RecyclerView.LayoutManager layoutManager_storage_files;
    //define needed for line separator on storage recycler view
    private static final int HORIZONTAL = 1;
    //dialog storage storage
    private AlertDialog.Builder dialogBuilder;
    private AlertDialog dialogDownloadStorage;
    private Button update_storage_files,cancel_storage_files;
    private ProgressBar progressbar_storage_files;
    private TextView status_storage_files;

    //file variables
    public File fileInt;
    public String intPath,extPath;

    //flag for the recording
    public boolean flag_stoprec=false;

    //flag to manage inflated views
    private boolean flag_manual_rec=false;
    private boolean flag_timer_rec=false;

    //flag to manage drawer while recording
    private boolean flag_home=false;
    private boolean flag_support=false;
    private boolean flag_logout=false;
    private boolean flag_closeapp=false;
    private boolean show_maps_flag = false;

    //flag for dead batteries show only once and save unit
    private static boolean flag_battery=false;
    private static String dead_battery_unit1 ="";
    private static String dead_battery_unit2 ="";
    private static String dead_battery_unit3 ="";
    private static String dead_battery_unit4 ="";
    private static String dead_battery_unit6 ="";

    //flag for download
    public boolean flag_filetoosmall = false;

    //backup variables
    private long size_interval_backupfile=1000; //initialize at each acquisition to 1000 (1 Mb)

    private String inforecordingtext="";
    private String old_inforecordingtext="";

    //DEFINES
    private static final float THRESHOLD_BATTERY = (float) 2.2;
    private static final int THRESHOLD_WATCHDOG_TIMER = 160; //DEFAULT: 40
    private static final int SIZE_INTERVAL_BACKUPFILE = 1000; //1000, each 1 Mb

    private ImageButton idicon,arrowback;
    private DrawerLayout drawerLayout;
    private RelativeLayout drawer_home, drawer_support,drawer_logout,drawer_closeapp;

    private FirebaseAuth mAuth;
    private FirebaseUser user;
    private DatabaseReference reference;
    private String userID;

    Toast toast;

    public final String LOG_TAG = IMUs_Saturation_Environmental.class.getSimpleName();

    // GESTIONE ANT
    private static final int USER_PERIOD_SENSORS = 819; // 1092; 30 Hz --> change to 819
    private static final int USER_PERIOD_ENVIRONMENTAL = 65535;
    private static final int USER_RADIOFREQUENCY = 66; //66, so 2466 MHz;
    public static boolean serviceIsBound_IMUs = false;
    public static boolean serviceIsBound_ENVIRONMENTAL = false;
    private AntService mAntRadioService = null;
    public AntChannelProvider antChannelProvider;
    public AntChannel antChannelIMUs;
    public AntChannel antChannelENVIRONMENTAL;
    public ChannelType antChannelIMUs_type;
    public AntMessage antMessage;
    public MessageFromAntType messagetype; //
    public boolean mIsOpen_IMUs = false;
    public boolean mIsOpen_ENVIRONMENTAL = false;
    public ChannelId channelId_smartphone_IMUs = new ChannelId(2,2,2, true); //DEFAULT: 2,2,2, true
    public ChannelId channelId_smartphone_ENVIRONMENTAL = new ChannelId(2,3,2, true); //DEFAULT: 2,2,2, true

    byte[] payLoad_IMUs;
    byte[] payLoad_ENVIRONMENTAL;

    byte[] payLoad1 = {0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01}; // payload to call unit 1 for the first time
    byte[] payLoad2 = {0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02}; // payload to call unit 2 for the first time
    byte[] payLoad3 = {0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03}; // payload to call unit 3 for the first time
    byte[] payLoad4 = {0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04}; // payload to call Pulse Ox for the first time
    byte[] payLoad6 = {0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06}; // payload to call Environmental Monitor for the first time

    byte[] payLoad7 = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // payload to synchronize the three units and to stop checking after calibration

    byte[] payLoad11 = {0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // payload to call unit 1 during acquisition
    byte[] payLoad12 = {0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // payload to call unit 2 during acquisition
    byte[] payLoad13 = {0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // payload to call unit 3 during acquisition
    byte[] payLoad14 = {0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // payload to call Pulse Ox during acquisition
    byte[] payLoad16 = {0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; // payload to call Environmental Monitor during acquisition

    byte[] payLoad8 = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, (byte) 0xFF}; // payload to calibrate and do movements, when sensors leds are off send payload 4 and go on
    byte[] payLoad9 = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, (byte) 0x80}; // payload to stop acquisition (resume) without close the channel (0x80=128) then send payload 4 and go on

    byte[] payLoad99 = {0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, (byte) 0xF}; // payload to wait

    public String string0 = "[00][00][00][00][00][00][00][00]";
    public String string1 = "[01][01][01][01][01][01][01]"; //message from slave 1 for check
    public String string2 = "[02][02][02][02][02][02][02]";//message from slave 2 for check
    public String string3 = "[03][03][03][03][03][03][03]";//message from slave 3 for check
    public String string4 = "[04][04][04][04][04][04][04]";//message from Pulse Ox for check
    public String string6 = "[06][06][06][06][06][06][06]";//message from Environmental Monitor for check

    public String dummy_unit1="[01],[00],[FF],[00],[00],[00],[00],[00],";
    public String dummy_unit2="[02],[00],[FF],[00],[00],[00],[00],[00],";
    public String dummy_unit3="[03],[00],[FF],[00],[00],[00],[00],[00],";
    public String dummy_unit4="[04],[00],[FF],[00],[00],[00],[00],[00],";
    public String dummy_unit6="[06],[00],[FF],[00],[00],[00],[00],[00],";

    public String startrec_time=null;

    public int state;
    public boolean connected1 = false;
    public boolean connected2 = false;
    public boolean connected3 = false;
    public boolean connected4 = false;
    public boolean connected6 = false;

    //STATES
    private static final int INITIALIZATION = 0;
    private static final int CONNECT1 = 1;
    private static final int CONNECT2 = 2;
    private static final int CONNECT3 = 3;
    private static final int CONNECT4 = 4;
    private static final int CONNECT6 = 6;
    private static final int SYNCHRONIZATION_RESUME = 7;
    private static final int START = 10;
    private static final int CALL1 = 11;
    private static final int CALL2 = 12;
    private static final int CALL3 = 13;
    private static final int CALL4 = 14;
    private static final int CALL6 = 16;
    private static final int CALIBRATION = 8; //payload 8
    private static final int STOP = 9; //stop and resume, payload 9
    private static final int RECONNECTION = 17;
    private static final int CLOSE = 0; //close the channel

    //STATES FOR PREVENT TO QUIT WITH BACK BUTTON DURING RECORDING AND SHOW A DIALOG
    private static final int QUIT_RECORDING = 12; //quit recording

    BroadcastDataMessage broadcastDataMessage;
    public String current_default,current,day, time, date;
    //save the old message to see if there's data loss
    public String old_messageContentString_unit=null;

    //watchdog timer to check if the sensors are receiving messages
    public int [] watchdog_timer={0,0,0,0}; //{UNIT1,UNIT2,UNI3, UNIT4}
    public int wt_unit1=0;
    public int wt_unit2=0;
    public int wt_unit3=0;
    public int wt_unit4=0;
    public int sumWt=0;
    public boolean flag_watchdog_timer_overflow = true;
    public boolean flag_reconnection = false;
    public boolean flag_sensors_disconnection = false;
    public boolean flag_sensors_disconnection_header = false;
    public String sensors_disconnection_header="You have to go back initialize the sensors because in the last recording a problem occurred with the communication.\n\nSwitch OFF the sensors ad then press YES";

    private String sensorsDisconnectedText;
    private static String sensorDisconnected1="";
    private static String sensorDisconnected2="";
    private static String sensorDisconnected3="";
    private static String sensorDisconnected4="";
    private static String sensorDisconnected5="";

    private static final int UNIT1 = 0;
    private static final int UNIT2 = 1;
    private static final int UNIT3 = 2;
    private static final int UNIT4 = 3;
    private static final int UNIT5 = 4;

    //dichiaro qua variabili per location
    public FusedLocationProviderClient fusedLocationClient;
    public LocationCallback locationCallback;
    public LocationRequest locationRequest;
    public Location location;
    public double latitude = 0.0, longitude = 0.0;

    //File management        per implementare l'aggiunta dei punti su maps (richiede accesso ai file con tutti i dati salvati)
    public File root; //root path of the file
    public File file; //file path
    public FileWriter writer;
    public String file_name; //name of the file

    //Activity recognition & map services       //non so se serve
//private GoogleApiClient apiClient;  //forse non serve, serve nella definizione della funzione?
    private LocalBroadcastManager localBroadcastManager;
    private BroadcastReceiver localActivityReceiver;
    public String activity;// = "STILL"; //activity level of the user (being still, walking or running)
    public SupportMapFragment mapFragment;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.imus_saturation_environmental);

        //FILES INT AND EXT INITIALIZATION
        //path where the txt file is saved internally before downloading
        intPath=getApplicationContext().getFilesDir().getAbsolutePath();

        //path where the root of the txt file is located on the smartphone
        extPath=getExternalFilesDir(null).getAbsolutePath();

        File folderInt=new File(intPath);

        fileInt=new File(folderInt,"demo");

        //STORAGE FILES INITIALIZATION
        //always clear the storage list and reload it
        item_storage_files=new ArrayList<>();

        //initialize the initialization view
        viewStub = (ViewStub) findViewById(R.id.initialization_toinclude);
        viewStub.setLayoutResource(R.layout.initialization_imus_saturation_environmental);
        inflated_initialization = viewStub.inflate();

        //update info layout initialization
        viewStub = (ViewStub) findViewById(R.id.updateinforecording_toinclude);
        viewStub.setLayoutResource(R.layout.updateinfo_recording);
        inflated_updateinfo = viewStub.inflate();

        viewStub = (ViewStub) findViewById(R.id.display_data_toinclude);
        viewStub.setLayoutResource(R.layout.display_data_environmental_monitor);
        inflated_displaydata = viewStub.inflate();

        posture_buttons=(RadioGroup) inflated_updateinfo.findViewById(R.id.posture_buttons);

        layout_insert_addinforec=(TextInputLayout) inflated_updateinfo.findViewById(R.id.layout_insert_addinforec);
        insert_addinforec=(TextInputEditText) inflated_updateinfo.findViewById(R.id.insert_addinforec);

        updateinfo=(Button) inflated_updateinfo.findViewById(R.id.updateinfo);
        updateinfo.setOnClickListener(this);

        inforecording=(TextView) inflated_updateinfo.findViewById(R.id.inforecording);

        inflated_updateinfo.setVisibility(View.GONE);
        inflated_displaydata.setVisibility(View.GONE);

        helpbutton = (Button) findViewById(R.id.helpbutton);
        helpbutton.setOnClickListener(this);

        telephone = (ImageButton) findViewById(R.id.telephone);
        telephone.setOnClickListener(this);

        storage = (ImageButton) findViewById(R.id.storage);
        storage.setOnClickListener(this);

        id_patient=(TextView) findViewById(R.id.card);
        id_patient.setText(GlobalVariables.string_idpatient);

        info_patient=(TextView) findViewById(R.id.info);
        info_patient.setText("INFO PATIENT: \n" + GlobalVariables.string_infopatient);

        //WARNINGS
        lowbattery_idpatient =(ImageView) findViewById(R.id.lowbattery_idpatient);
        lowbattery_idpatient.setOnClickListener(this);
        lowbattery_idpatient.setVisibility(View.GONE);
        error_idpatient=(ImageButton) findViewById(R.id.error_idpatient);
        error_idpatient.setVisibility(View.GONE);
        exclamation_point_idpatient=(ImageButton) findViewById(R.id.exclamation_point_idpatient);
        exclamation_point_idpatient.setOnClickListener(this);
        exclamation_point_idpatient.setVisibility(View.GONE);
        checkmark_idpatient=(ImageButton) findViewById(R.id.checkmark_idpatient);
        checkmark_idpatient.setOnClickListener(this);
        checkmark_idpatient.setVisibility(View.GONE);
        progressbar_idpatient=(ProgressBar) findViewById(R.id.progressbar_idpatient);
        progressbar_idpatient.setVisibility(View.GONE);

        initializationbutton=(Button) findViewById(R.id.initializationbutton);
        initializationbutton.setOnClickListener(this);

        gotoswitchonsensors=(Button) findViewById(R.id.gotoswitchonsensors);
        gotoswitchonsensors.setOnClickListener(this);

        progressbar_initialization=(ProgressBar) findViewById(R.id.progressbar_initialization);
        status_initialization=(TextView) findViewById(R.id.status_initialization);
        bottom_initialization=(TextView) findViewById(R.id.bottom_initialization);

        initialization_checkmark=(ImageButton) findViewById(R.id.initialization_checkmark);

        //PER STAMPARE A SCHERMO
        temperature_output = (TextView) findViewById(R.id.temperature_value);
        humidity_output = (TextView) findViewById(R.id.humidity_value);
        pressure_output = (TextView) findViewById(R.id.pressure_value);
        CO2_output = (TextView) findViewById(R.id.CO2_value);
        VOC_output = (TextView) findViewById(R.id.VOC_value);
        NO2_output = (TextView) findViewById(R.id.NO2_value);
        CO_output = (TextView) findViewById(R.id.CO_value);
        PM1p0_output = (TextView) findViewById(R.id.PM1_0_value);
        PM2p5_output = (TextView) findViewById(R.id.PM2_5_value);
        PM10_output = (TextView) findViewById(R.id.PM10_value);

        //BINDING TO THE ANT RADIO SERVICE
        serviceIsBound_IMUs = AntService.bindService(this, mAntRadioServiceConnection);
        Log.e(LOG_TAG, "Ant Service is bound: "+ serviceIsBound_IMUs);
        Log.e(LOG_TAG, "Version name: "+ AntService.getVersionName(this));

        drawerLayout=findViewById(R.id.drawer_layout);

        drawer_home=findViewById(R.id.drawer_home);
        drawer_home.setOnClickListener(this);

        drawer_support =findViewById(R.id.drawer_support);
        drawer_support.setOnClickListener(this);

        drawer_logout=findViewById(R.id.drawer_logout);
        drawer_logout.setOnClickListener(this);

        drawer_closeapp=findViewById(R.id.drawer_closeapp);
        drawer_closeapp.setOnClickListener(this);

        idicon=findViewById(R.id.idicon);
        idicon.setOnClickListener(this);

        arrowback=findViewById(R.id.arrowback);
        arrowback.setOnClickListener(this);

        final TextView drawerMail=(TextView) findViewById(R.id.drawermail);
        final TextView drawerFullname=(TextView) findViewById(R.id.drawerfullname);

        //check the user info to display on drawer
        mAuth=FirebaseAuth.getInstance();
        user=mAuth.getCurrentUser();
        reference= FirebaseDatabase.getInstance().getReference("Users");

        Log.e(LOG_TAG, "IN DEMO DOWNLOAD "  );

        //if the user is not null
        if(user!=null){
            userID=user.getUid();

            reference.child(userID).addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(@NonNull @NotNull DataSnapshot snapshot) {
                    User userDrawer=snapshot.getValue(User.class);

                    if(userDrawer !=null){
                        String mail=userDrawer.mail;
                        String fullname=userDrawer.fullname;
                        drawerMail.setText(mail);
                        drawerFullname.setText(fullname);
                    }
                }

                @Override
                public void onCancelled(@NonNull @NotNull DatabaseError error) {
                    Toast.makeText(getApplicationContext(), "Something wrong happen", Toast.LENGTH_LONG).show();
                }
            });
        }

        //LOCATION PROVIDER
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
        locationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                if (locationResult != null) {
                    location = locationResult.getLastLocation();
                    latitude = location.getLatitude();
                    longitude = location.getLongitude();
                }
            }
        };

        locationRequest = LocationRequest.create();
        locationRequest.setInterval(10000);
        locationRequest.setFastestInterval(2500);
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

    }


    //variabili per la gestione dei pacchetti Environmental e scrittura dei dati su file
    int pacchetto_numero_ricevuto;   //numero incrementale del pacchetto che arriva
    int numero_pacchetto = 1;
    int pacchetto_P = 0;   //numero del pacchetto P arrivato
    int flag_dati_ricevuti = 0;
    int flag_location = 0;
    int count_P1 = 0;
    int count_P2 = 0;
    int count_P3 = 0;
    //variabili per contenere i valori inviati
    float temperature = 0;
    float humidity = 0;
    int pressure = 0;
    int VOC = 0;
    int CO2 = 0;
    float NO2 = 0;
    float CO = 0;
    float battery = 0;
    int acceleration = 0;
    float PM1p0 = 0;
    float PM2p5 = 0;
    float PM10p0 = 0;
    float partial_calculation = 0; //variabile usata per fare calcoli parziali
    String messaggio_salvato;


    //TODO-- ANT HANDLER ANCORA DA SISTEMARE
    public IAntChannelEventHandler eventCallBack = new IAntChannelEventHandler() {

        @RequiresApi(api = Build.VERSION_CODES.O)
        @Override
        public void onReceiveMessage(MessageFromAntType messageFromAntType, AntMessageParcel antMessageParcel) {

            switch(messageFromAntType){

                case BROADCAST_DATA: //HERE ARRIVES ALL THE MESSAGES FROM THE SENSORS

                    //save time
                    day= LocalDateTime.now().toLocalDate().toString(); //datetime

                    //save time to show
                    SimpleDateFormat format=new SimpleDateFormat("dd:MM:HH:mm:ss:SSS", Locale.getDefault());
                    current=format.format(new Date().getTime());

                    String messageContentString_default = antMessageParcel.getMessageContentString(); //9 bytes, first is always [00] (to erase)

                    //remove the first byte always equal to [00]
                    //OFFICIAL MESSAGE messageContentString
                    String messageContentString=messageContentString_default.substring(4); //8 bytes, correct. Ex:"[03][5C][00][00][62][2E][3C][E8]"

                    //the following string is used to be uploaded on firebase and to be written on the file .txt, it has the same format of the messages needed for the ANALISI_SEGNALE_FAST.py
                    //example output format: [02],[5b],[00],[00],[16],[c2],[5e],[cb],
                    String msg= messageContentString.substring(0,4) + ","
                            + messageContentString.substring(4,8) + ","
                            + messageContentString.substring(8,12) + ","
                            + messageContentString.substring(12,16) + ","
                            + messageContentString.substring(16,20) + ","
                            + messageContentString.substring(20,24) + ","
                            + messageContentString.substring(24,28) + ","
                            + messageContentString.substring(28,32) + ",";

                    //TODO - end

                    //split the bytes
                    String[] messageContentString_split = messageContentString.split("]"); //ex: [01
                    //get the first byte to find the unit and remove the open square bracket
                    String messageContentString_unit=messageContentString_split[0].substring(1); //ex: 01

                    //if ALL the units are connected, the next messages will be the recording data
                    if(connected1 && connected2 && connected3 && connected4 && connected6){



                        if(messageContentString_unit.equals("01") || messageContentString_unit.equals("02") || messageContentString_unit.equals("03") || messageContentString_unit.equals("04")) {
                            Log.e(LOG_TAG, "pacchetto IMUs o saturimetro");
                            //if the message is received, reset watchdog timer of the unit received
                            String unitReceived_default=messageContentString_unit.substring(1); //ex: 1 (String)
                            int unitReceived=Integer.decode("0x"+ unitReceived_default); //ex: 1 (int)
                            resetWatchdogTimer(unitReceived-1); //we subtract 1 to match the array indexes


                            //TODO- dummy messages for data loss - IT WORKSSSSS - find a less cpu solution
                            //if recording started, look for data loss in each unit and eventually add a dummy message.
                            //we check the unit of the previous message.
                            //if it's different respect to the correct order, the units missing can be:
                            // 1 --> we send a dummy message of the previous unit missing
                            // 2 --> we send two dummy messages of the previous units missing

                            //the first time we acces old_messageContentString is null, so we won't add any dummy messages
                            //always initialize old_messageContentString as null

                            if (old_messageContentString_unit != null) {
                                //Log.e(LOG_TAG,"old_messageContentString_unit not null");
                                if ((messageContentString_unit.equals("01")) && (!old_messageContentString_unit.equals("04"))) {
                                    //Log.e(LOG_TAG,dummy_unit3);
                                    if (old_messageContentString_unit.equals("01")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit2 + current, startrec_time);
                                        writingDataToFirebase.mainFirebase(dummy_unit3 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit2 + current, current, day, intPath, extPath);
                                        writingDataToFile.mainFile(dummy_unit3 + current, current, day, intPath, extPath);

                                    } else if (old_messageContentString_unit.equals("02")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit3 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit3 + current, current, day, intPath, extPath);
                                    }


                                    //call the firebase class to upload data on firebase
                                    WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                    writingDataToFirebase.mainFirebase(dummy_unit4 + current, startrec_time);

                                    //call the file class to save data in a txt file
                                    WritingDataToFile writingDataToFile = new WritingDataToFile();
                                    writingDataToFile.mainFile(dummy_unit4 + current, current, day, intPath, extPath);
                                } else if ((messageContentString_unit.equals("02")) && (!old_messageContentString_unit.equals("01"))) {
                                    //Log.e(LOG_TAG,dummy_unit1);
                                    if (old_messageContentString_unit.equals("02")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit3 + current, startrec_time);
                                        writingDataToFirebase.mainFirebase(dummy_unit4 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit3 + current, current, day, intPath, extPath);
                                        writingDataToFile.mainFile(dummy_unit4 + current, current, day, intPath, extPath);
                                    } else if (old_messageContentString_unit.equals("03")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit4 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit4 + current, current, day, intPath, extPath);
                                    }

                                    //call the firebase class to upload data on firebase
                                    WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                    writingDataToFirebase.mainFirebase(dummy_unit1 + current, startrec_time);

                                    //call the file class to save data in a txt file
                                    WritingDataToFile writingDataToFile = new WritingDataToFile();
                                    writingDataToFile.mainFile(dummy_unit1 + current, current, day, intPath, extPath);
                                } else if ((messageContentString_unit.equals("03")) && (!old_messageContentString_unit.equals("02"))) {
                                    //Log.e(LOG_TAG,dummy_unit2);
                                    if (old_messageContentString_unit.equals("03")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit4 + current, startrec_time);
                                        writingDataToFirebase.mainFirebase(dummy_unit1 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit4 + current, current, day, intPath, extPath);
                                        writingDataToFile.mainFile(dummy_unit1 + current, current, day, intPath, extPath);
                                    } else if (old_messageContentString_unit.equals("04")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit1 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit1 + current, current, day, intPath, extPath);
                                    }

                                    //call the firebase class to upload data on firebase
                                    WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                    writingDataToFirebase.mainFirebase(dummy_unit2 + current, startrec_time);

                                    //call the file class to save data in a txt file
                                    WritingDataToFile writingDataToFile = new WritingDataToFile();
                                    writingDataToFile.mainFile(dummy_unit2 + current, current, day, intPath, extPath);
                                } else if ((messageContentString_unit.equals("04")) && (!old_messageContentString_unit.equals("03"))) {
                                    //Log.e(LOG_TAG,dummy_unit2);
                                    if (old_messageContentString_unit.equals("04")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit1 + current, startrec_time);
                                        writingDataToFirebase.mainFirebase(dummy_unit2 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit1 + current, current, day, intPath, extPath);
                                        writingDataToFile.mainFile(dummy_unit2 + current, current, day, intPath, extPath);
                                    } else if (old_messageContentString_unit.equals("01")) {
                                        //call the firebase class to upload data on firebase
                                        WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                        writingDataToFirebase.mainFirebase(dummy_unit2 + current, startrec_time);

                                        //call the file class to save data in a txt file
                                        WritingDataToFile writingDataToFile = new WritingDataToFile();
                                        writingDataToFile.mainFile(dummy_unit2 + current, current, day, intPath, extPath);
                                    }

                                    //call the firebase class to upload data on firebase
                                    WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                                    writingDataToFirebase.mainFirebase(dummy_unit3 + current, startrec_time);

                                    //call the file class to save data in a txt file
                                    WritingDataToFile writingDataToFile = new WritingDataToFile();
                                    writingDataToFile.mainFile(dummy_unit3 + current, current, day, intPath, extPath);
                                }

                            }
                            //save the previous unit of the message to constantly check the order
                            old_messageContentString_unit = messageContentString_unit;

                            //TODO-END implement dummy messages for data loss

                            //TODO- write the message to firebase and to file
                            //write the messages
                            //call the firebase class to upload data on firebase
                            WritingDataToFirebase writingDataToFirebase = new WritingDataToFirebase();
                            writingDataToFirebase.mainFirebase(msg + current, startrec_time);

                            //call the file class to save data in a txt file
                            WritingDataToFile writingDataToFile = new WritingDataToFile();
                            writingDataToFile.mainFile(msg + current, current, day, intPath, extPath);

                            fileInt = writingDataToFile.fileInt; //get fileInt to use for storage function and save on firebase

                            //TODO - every now and then save the file on firebase for backup, later savings will over write the previous one
                            /*//save the file each 1 MB size (around 10 minutes)
                            long fileIntSizeBytes_backup = fileInt.length();
                            long fileIntSizeKyloBytes_backup = fileIntSizeBytes_backup / 1024;

                            if (fileIntSizeKyloBytes_backup > size_interval_backupfile && fileIntSizeKyloBytes_backup < size_interval_backupfile + 50) {
                                //Log.e("backup","backup 1, size start: " + size_interval_backupfile);
                                saveFileOnFirebase(fileInt);
                                size_interval_backupfile = size_interval_backupfile + SIZE_INTERVAL_BACKUPFILE;
                                //Log.e("backup","backup 1, size end: " + size_interval_backupfile);
                            }
                            */
                            //TODO- warning for low battery
                            //get the second byte to find the battery hex value and remove the open square bracket
                            String messageContentString_battery = messageContentString_split[1].substring(1); //ex: 5C
                            float battery_unit = convertToBattery(messageContentString_battery);

                            //demo line to force the value and check if the warning appears and the following if statement
                            //battery_unit= (float) 1.0;

                            //check battery value in volt
                            //TIP: the value 81 in int represents the battery value of 2.2
                            //Log.e("demo","Unit " + messageContentString_unit+" battery "+battery_unit);

                            if ((battery_unit < THRESHOLD_BATTERY) && (battery_unit > 0.1)) {

                                if (messageContentString_unit.equals("01")) {
                                    dead_battery_unit1 = "1";
                                }
                                if (messageContentString_unit.equals("02")) {
                                    dead_battery_unit2 = "2";
                                }
                                if (messageContentString_unit.equals("03")) {
                                    dead_battery_unit3 = "3";
                                }
                                if (messageContentString_unit.equals("04")) {
                                    dead_battery_unit4 = "4";
                                }


                                if (flag_battery) {

                                    //to change the UI we have to put codes in the runOnUiThread
                                    runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            lowbattery_idpatient.setVisibility(View.VISIBLE);
                                            checkmark_idpatient.setVisibility(View.VISIBLE);
                                        }
                                    });
                                    //so the warning is shown only once
                                    flag_battery = false;
                                }
                            }
                            //else show the green checkmark
                            else {
                                //with this flag the visibility is set only once
                                if (flag_battery) {

                                    //to change the UI we have to put codes in the runOnUiThread
                                    runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            lowbattery_idpatient.setVisibility(View.GONE);
                                            checkmark_idpatient.setVisibility(View.VISIBLE);
                                        }
                                    });
                                    //so the warning is shown only once
                                    flag_battery = false;
                                }
                            }
                            //TODO- end warning for low battery
                        }
                        else{

                            Log.e(LOG_TAG, "Pacchetto Environmental: " + msg); //hex
                            pacchetto_numero_ricevuto = Integer.decode("0x"+messageContentString_split[0].substring(1));
                            pacchetto_P = pacchetto_numero_ricevuto >> 6;
                            pacchetto_numero_ricevuto = pacchetto_numero_ricevuto - (pacchetto_P << 6);
                            WritingDataToFirebase writingDataToFirebase= new WritingDataToFirebase();
                            WritingDataToFile writingDataToFile = new WritingDataToFile();
                            if (numero_pacchetto != pacchetto_numero_ricevuto){
                                //Toast.makeText(getApplicationContext(), "Pacchetto Nuovo", Toast.LENGTH_LONG).show();
                                if (flag_dati_ricevuti == 1){               //scrivo su file
                                    //preparo messaggio da salvare
                                    messaggio_salvato = 6 + ";" + numero_pacchetto +  ";" +//per indicare pacchetto di environmental monitor
                                            temperature + ";" + humidity + ";" + pressure + ";" +
                                            VOC + ";" + CO2 + ";" + NO2 + ";" + CO + ";" +
                                            PM1p0 + ";" + PM2p5 + ";" + PM10p0 + ";" + acceleration + ";" +
                                            count_P1 + ";" + count_P2 + ";" + count_P3 + ";" +
                                            date + ";" + time + ";" + latitude + ";" + longitude + ";";    //valore batteria lo salvo?

                                    //toast.makeText(getApplicationContext(), "scrivo su file" , Toast.LENGTH_SHORT).show();

                                    //write the messages
                                    //call the firebase class to upload data on firebase
                                    //WritingDataToFirebase writingDataToFirebase= new WritingDataToFirebase();
                                    writingDataToFirebase.mainFirebase(messaggio_salvato,startrec_time);
                                    //scrivo su file
                                    //WritingDataToFile writingDataToFile = new WritingDataToFile();
                                    writingDataToFile.mainFile(messaggio_salvato, current, day, intPath,extPath);

                                    fileInt= writingDataToFile.fileInt; //get fileInt to use for storage function and save on firebase

                                }
                                else{
                                    //salvo i valori su file e firebase
                                    //gestire che alcuni dati sono persi
                                    numero_pacchetto = pacchetto_numero_ricevuto;
                                    //toast.makeText(getApplicationContext(),"pacchetti persi", Toast.LENGTH_SHORT).show();

                                    //gestione ricezione parziale dei pacchetti
                                    if (count_P1 == 0){ //non ho ricevuto il pacchetto P1
                                        messaggio_salvato = 6 + ";" + numero_pacchetto + ";"  + //per indicare pacchetto di environmental monitor
                                                "0" + ";" + "0" + ";" + "0" + ";";
                                    }
                                    else{
                                        messaggio_salvato = 6 + ";" +  numero_pacchetto + ";"  + //per indicare pacchetto di environmental monitor
                                                temperature + ";" + humidity + ";" + pressure + ";";
                                    }
                                    if(count_P2 == 0){
                                        messaggio_salvato = messaggio_salvato +
                                                "0" + ";" + "0" + ";" + "0" + ";" + "0" + ";";
                                    }
                                    else{
                                        messaggio_salvato = messaggio_salvato +
                                                VOC + ";" + CO2 + ";" + NO2 + ";" + CO + ";";
                                    }
                                    if(count_P3 == 0){
                                        messaggio_salvato = messaggio_salvato +
                                                "0" + ";" + "0" + ";" + "0" + ";" + "0" + ";";
                                    }
                                    else{
                                        messaggio_salvato = messaggio_salvato +
                                                PM1p0 + ";" + PM2p5 + ";" + PM10p0 + ";" + acceleration + ";";
                                    }

                                    messaggio_salvato = messaggio_salvato + count_P1 + ";" + count_P2 + ";" + count_P3 + ";"
                                                            + date + ";" + time + ";" + latitude + ";" + longitude;
                                    //do per scontato che almeno un pacchetto sia arrivato, e quindi ho latitudine longitudine e ora

                                    //write the messages
                                    //call the firebase class to upload data on firebase
                                    //WritingDataToFirebase writingDataToFirebase= new WritingDataToFirebase();
                                    writingDataToFirebase.mainFirebase(messaggio_salvato,startrec_time);
                                    //scrivo su file
                                    //WritingDataToFile writingDataToFile = new WritingDataToFile();
                                    writingDataToFile.mainFile(messaggio_salvato, current, day, intPath,extPath);

                                    fileInt= writingDataToFile.fileInt; //get fileInt to use for storage function and save on firebase
                                }

                                numero_pacchetto = pacchetto_numero_ricevuto;
                                flag_dati_ricevuti = 0;

                                count_P1 = 0;
                                count_P2 = 0;
                                count_P3 = 0;
                                flag_location = 0;
                            }
                            if (numero_pacchetto == pacchetto_numero_ricevuto ) {
                                //la prima volta che entro in questo if, devo prendere latitudine e longitudine
                                if (flag_location == 0) {
                                    if (ActivityCompat.checkSelfPermission(IMUs_Saturation_Environmental.this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED)
                                        ActivityCompat.requestPermissions(IMUs_Saturation_Environmental.this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION}, 1);
                                    Log.e(LOG_TAG, "GEOLOCALIZZAZIONE "); //hex

                                    Calendar calendar = null;
                                    calendar = calendar.getInstance();

                                    int year = calendar.get(Calendar.YEAR);
                                    int month = calendar.get(Calendar.MONTH) + 1;
                                    int day = calendar.get(Calendar.DAY_OF_MONTH);
                                    int hour = calendar.get(Calendar.HOUR_OF_DAY);
                                    int minute = calendar.get(Calendar.MINUTE);
                                    int second = calendar.get(Calendar.SECOND);

                                    date = day + "/" + month + "/" + year;
                                    time = hour + ":" + minute + ":" + second;
                                    Log.e(LOG_TAG, "data: " + day +"/"+ month +"/"+ year+"; "
                                            + hour + ":" + minute + ":" + second); //hex

                                    Task<Location> task = fusedLocationClient.getLastLocation();
                                    while (!task.isComplete()) ;
                                    location = task.getResult();

                                    if (location == null)
                                        toast.makeText(getApplicationContext(), "Unable to find last location.", Toast.LENGTH_SHORT).show();
                                    else { //actually open the channel only if last location was found
                                        latitude = location.getLatitude();
                                        longitude = location.getLongitude();
                                    }

                                    flag_location = 1;  //solo la prima volta rilevo le coordinate
                                }
                                switch (pacchetto_P) {
                                    case 1:
                                        //toast.makeText(getApplicationContext(), "P1" , Toast.LENGTH_SHORT).show();
                                        count_P1++;
                                        if (count_P1 == 1) {
                                            //ricostruisco i dati in variabili
                                            //Temperature
                                            partial_calculation = (Integer.decode("0x" + messageContentString_split[1].substring(1)) - 30);
                                            if (partial_calculation > 0) {
                                                temperature = partial_calculation + ((float) Integer.decode("0x" + messageContentString_split[2].substring(1)) / 100);
                                            } else {
                                                temperature = partial_calculation - ((float) Integer.decode("0x" + messageContentString_split[2].substring(1)) / 100);
                                            }
                                            //humidity
                                            humidity = Integer.decode("0x" + messageContentString_split[3].substring(1)) + ((float) Integer.decode("0x" + messageContentString_split[4].substring(1)) / 100);
                                            //pressure
                                            pressure = (Integer.decode("0x" + messageContentString_split[5].substring(1)) << 16) + (Integer.decode("0x" + messageContentString_split[6].substring(1)) << 8) + Integer.decode("0x" + messageContentString_split[7].substring(1));

                                            //mostri dati a schermo
                                            runOnUiThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    temperature_output.setText(String.valueOf(temperature));
                                                    humidity_output.setText(String.valueOf(humidity));
                                                    pressure_output.setText(String.valueOf(pressure));
                                                }
                                            });

                                        }
                                        break;

                                    case 2:
                                        //toast.makeText(getApplicationContext(), "P2" , Toast.LENGTH_SHORT).show();
                                        count_P2 ++;
                                        if (count_P2 == 1) {
                                            //ricostruisco i dati in variabili
                                            //VOC
                                            VOC = Integer.decode("0x" + messageContentString_split[1].substring(1)) + (Integer.decode("0x" + messageContentString_split[2].substring(1)) <<8);
                                            //CO2
                                            CO2 = Integer.decode("0x" + messageContentString_split[3].substring(1)) + (Integer.decode("0x" + messageContentString_split[4].substring(1)) <<8);
                                            //NO2 bisogna riportare la funzione di conversione da bit a valore dopo aver fatto la calibrazione
                                            NO2 = Integer.decode("0x" + messageContentString_split[5].substring(1));
                                            NO2 = (float) Math.pow(10,(Math.log10(NO2/231)-0.804)/1.026);   //hard coding 234 valore normale
                                            NO2 = Math.round(NO2 *100);
                                            NO2 = NO2 / 100;
                                            //CO
                                            CO = Integer.decode("0x" + messageContentString_split[6].substring(1));
                                            CO = (float) Math.pow(10, ((Math.log10(CO/229)-0.55)/(-0.85)));
                                            CO = Math.round(CO * 100);
                                            CO = CO /100;
                                            //Batteria
                                            battery = Integer.decode("0x" + messageContentString_split[7].substring(1));

                                            //mostri dati a schermo
                                            runOnUiThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    VOC_output.setText(String.valueOf(VOC));
                                                    CO2_output.setText(String.valueOf(CO2));
                                                    if (CO2 > 1000){
                                                        CO2_output.setTextColor(Color.MAGENTA);
                                                    }
                                                    else {
                                                        CO2_output.setTextColor(Color.BLACK);
                                                    }
                                                    CO_output.setText(String.valueOf(CO));
                                                    NO2_output.setText(String.valueOf(NO2));
                                                }
                                            });
                                        }
                                        break;

                                    case 3:
                                        //toast.makeText(getApplicationContext(), "P3" , Toast.LENGTH_SHORT).show();
                                        count_P3 ++;
                                        if (count_P3 == 1) {
                                            //ricostruisco i dati in variabili
                                            //acceleration
                                            acceleration = Integer.decode("0x" + messageContentString_split[1].substring(1));
                                            //PM1.0
                                            PM1p0 = Integer.decode("0x" + messageContentString_split[2].substring(1)) + Integer.decode("0x" + messageContentString_split[3].substring(1))/100;
                                            //PM2.5
                                            PM2p5 = Integer.decode("0x" + messageContentString_split[4].substring(1)) + Integer.decode("0x" + messageContentString_split[5].substring(1))/100;
                                            //PM10
                                            PM10p0 = Integer.decode("0x" + messageContentString_split[6].substring(1)) + Integer.decode("0x" + messageContentString_split[7].substring(1))/100;

                                            //mostri dati a schermo
                                            runOnUiThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    PM1p0_output.setText(String.valueOf(PM1p0));

                                                    PM2p5_output.setText(String.valueOf(PM2p5));            //15
                                                    if (PM2p5 >15)
                                                        PM2p5_output.setTextColor(Color.MAGENTA);
                                                    else
                                                        PM2p5_output.setTextColor(Color.BLACK);

                                                    PM10_output.setText(String.valueOf(PM10p0));            //45        limite annuale
                                                    if (PM10p0 > 45)
                                                        PM10_output.setTextColor(Color.MAGENTA);
                                                    else
                                                        PM10_output.setTextColor(Color.BLACK);
                                                }
                                            });
                                        }
                                        break;
                                }
                                if (count_P1 > 0 && count_P2 > 0 && count_P3 > 0 && flag_dati_ricevuti == 0){ //condizione: almeno un pacchetto P per ognuno è arrivato

                                    flag_dati_ricevuti = 1;
                                }

                                //controllo batteria
//TODO- controllare soglia batteria
                                if (battery < 250)
                                    dead_battery_unit6 = "6";
                            }

                        }

                        //save the file each 1 MB size (around 10 minutes)
                        long fileIntSizeBytes_backup = fileInt.length();
                        long fileIntSizeKyloBytes_backup = fileIntSizeBytes_backup / 1024;

                        if (fileIntSizeKyloBytes_backup > size_interval_backupfile && fileIntSizeKyloBytes_backup < size_interval_backupfile + 50) {
                            //Log.e("backup","backup 1, size start: " + size_interval_backupfile);
                            saveFileOnFirebase(fileInt);
                            size_interval_backupfile = size_interval_backupfile + SIZE_INTERVAL_BACKUPFILE;
                            //Log.e("backup","backup 1, size end: " + size_interval_backupfile);
                        }

                    }
                    else { //if the three units are NOT connected, check each one in the "switch on sensors" layout

                        Log.e(LOG_TAG, "CHECK Rx: " + messageContentString); //hex

                        if(messageContentString.contains(string1)   && connected1 == false){
                            connected1 = true;
                            //GlobalVariables.flag_connected1=true;
                            Log.e(LOG_TAG,"1 is:" + connected1);
                            state=CONNECT2;

                            //to change the UI we have to put codes in the runOnUiThread
                            runOnUiThread(new Runnable() {

                                @Override
                                public void run() {
                                    switchonsensor1_progressbar.setVisibility(View.GONE);
                                    switchonsensor1_checkmark.setVisibility(View.VISIBLE);

                                    switchonsensor2.setVisibility(View.VISIBLE);
                                    switchonsensor2_progressbar.setVisibility(View.VISIBLE);
                                }
                            });
                        }

                        if(messageContentString.contains(string2) && connected1 == true){
                            connected2 = true;
                            Log.e(LOG_TAG,"2 is:" + connected2);
                            state=CONNECT3;

                            //to change the UI we have to put codes in the runOnUiThread
                            runOnUiThread(new Runnable() {

                                @Override
                                public void run() {
                                    switchonsensor2_progressbar.setVisibility(View.GONE);
                                    switchonsensor2_checkmark.setVisibility(View.VISIBLE);

                                    switchonsensor3.setVisibility(View.VISIBLE);
                                    switchonsensor3_progressbar.setVisibility(View.VISIBLE);
                                }
                            });
                        }

                        if(messageContentString.contains(string3)   && connected2 == true){
                            connected3 = true;
                            Log.e(LOG_TAG,"3 is:" + connected3);
                            state=CONNECT4;
                            //to change the UI we have to put codes in the runOnUiThread
                            runOnUiThread(new Runnable() {

                                @Override
                                public void run() {
                                    switchonsensor3_progressbar.setVisibility(View.GONE);
                                    switchonsensor3_checkmark.setVisibility(View.VISIBLE);

                                    switchonsensor4.setVisibility(View.VISIBLE);
                                    switchonsensor4_progressbar.setVisibility(View.VISIBLE);

                                }
                            });
                        }

                        if(messageContentString.contains(string4)   && connected3 == true){
                            connected4 = true;
                            Log.e(LOG_TAG,"4 is:" + connected4);
                            state=CONNECT6;
                            //to change the UI we have to put codes in the runOnUiThread
                            runOnUiThread(new Runnable() {

                                @Override
                                public void run() {
                                    switchonsensor4_progressbar.setVisibility(View.GONE);
                                    switchonsensor4_checkmark.setVisibility(View.VISIBLE);

                                    switchonsensor6.setVisibility(View.VISIBLE);
                                    switchonsensor6_progressbar.setVisibility(View.VISIBLE);

                                }
                            });
                        }
                        if(messageContentString.contains(string6)   && connected4 == true){
                            connected6 = true;
                            Log.e(LOG_TAG,"6 is:" + connected6);
                            //to change the UI we have to put codes in the runOnUiThread
                            runOnUiThread(new Runnable() {

                                @Override
                                public void run() {
                                    switchonsensor6_progressbar.setVisibility(View.GONE);
                                    switchonsensor6_checkmark.setVisibility(View.VISIBLE);

                                    //show green checkmark
                                    checkmark_idpatient.setVisibility(View.VISIBLE);
                                    lowbattery_idpatient.setVisibility(View.GONE);
                                    progressbar_idpatient.setVisibility(View.GONE);

                                    //put the flag on to check the battery to display warning once
                                    flag_battery=true;

                                    gotorecordingbutton.setVisibility(View.VISIBLE);
                                }
                            });
                        }


                    }

                    break;

                case CHANNEL_ID:
                    Log.e(LOG_TAG, "CASE CHANNEL ID");
                    break;

                case CHANNEL_EVENT:

                    //Log.e(LOG_TAG, "antMessageParcel" + antMessageParcel);
                    String MessageId = antMessageParcel.getMessageContentString();
                    //Log.e(LOG_TAG, "MessageId" + MessageId);

                    ChannelEventMessage eventMessage = new ChannelEventMessage(antMessageParcel);
                    switch (eventMessage.getEventCode()) {
                        case RX_SEARCH_TIMEOUT:
                            break;
                        case RX_FAIL:
                            break;
                        case TX: //HERE WE SEND ALL THE BROADCAST MESSAGES TO THE SENSORS
                            //if the channel has been opened during initialization...
                            if (mIsOpen_IMUs && mIsOpen_ENVIRONMENTAL) {

                                if( MessageId.equals("[00][01][03]")) {  //Canale IMUs
                                    Log.e(LOG_TAG, "IMUs");

                                    // Setting the data to be broadcast on the next channel period
                                    if (state == CONNECT1) {
                                        payLoad_IMUs = payLoad1;
                                        Log.e(LOG_TAG, "CONNECT1");
                                    }

                                    if (state == CONNECT2) {
                                        payLoad_IMUs = payLoad2;
                                        Log.e(LOG_TAG, "CONNECT2");
                                    }

                                    if (state == CONNECT3) {
                                        payLoad_IMUs = payLoad3;
                                        Log.e(LOG_TAG, "CONNECT3");
                                    }
                                    if (state == CONNECT4) {
                                        payLoad_IMUs = payLoad4;
                                        Log.e(LOG_TAG, "CONNECT4");
                                    }
                                    if(state == CONNECT6){//connect environmental in the other channel
                                        payLoad_IMUs = payLoad99;
                                    }

                                    if (state == SYNCHRONIZATION_RESUME) {
                                        payLoad_IMUs = payLoad7;
                                    }

                                    if (state == RECONNECTION) {
                                        payLoad_IMUs = payLoad7;
                                    }

                                    if (state == START) {
                                        payLoad_IMUs = payLoad7;
                                        //save time to show
                                        SimpleDateFormat formatStartRec = new SimpleDateFormat("dd:MM:HH:mm:ss:SSS", Locale.getDefault());
                                        startrec_time = formatStartRec.format(new Date().getTime());
                                        Log.e("start", "New rec: " + startrec_time);
                                    }

                                    if (state == CALL1) {
                                        payLoad_IMUs = payLoad11;
                                    }

                                    if (state == CALL2) {
                                        payLoad_IMUs = payLoad12;
                                    }

                                    if (state == CALL3) {
                                        payLoad_IMUs = payLoad13;
                                    }

                                    if (state == CALL4) {
                                        payLoad_IMUs = payLoad14;
                                    }

                                    if (state == CALIBRATION) {
                                        payLoad_IMUs = payLoad8;
                                    }

                                    if (state == STOP) {
                                        //stop the channel sending the payload9
                                        payLoad_IMUs = payLoad9;
                                    }

                                    //send the message through a specific payload
                                    try {
                                        antChannelIMUs.setBroadcastData(payLoad_IMUs);
                                    } catch (RemoteException e) {
                                        e.printStackTrace();
                                    }

                                    //CONTINUOUS ACQUISITION
                                    //after synchronization (START), call periodically one after the other
                                    if (state == START || state == RECONNECTION) {
                                        state = CALL1;
                                        startWatchdogTimer(UNIT1);
                                        checkWatchdogTimer();
                                        //start geolocalization update service
                                        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper());
                                    } else if (state == CALL1) {
                                        state = CALL2;
                                        startWatchdogTimer(UNIT2);
                                        checkWatchdogTimer();
                                    } else if (state == CALL2) {
                                        state = CALL3;
                                        startWatchdogTimer(UNIT3);
                                        checkWatchdogTimer();
                                    } else if (state == CALL3) {
                                        state = CALL4;
                                        startWatchdogTimer(UNIT4);
                                        checkWatchdogTimer();
                                    } else if (state == CALL4) {
                                        state = CALL1;
                                        startWatchdogTimer(UNIT1);
                                        checkWatchdogTimer();
                                    }
                                }

                                if( MessageId.equals("[01][01][03]")){  //Canale environmental
                                    Log.e(LOG_TAG, "Environmental");

                                    if(state == CONNECT1){
                                        payLoad_ENVIRONMENTAL = payLoad99;
                                    }

                                    if(state==CONNECT2) {
                                        payLoad_ENVIRONMENTAL = payLoad99;
                                    }

                                    if(state==CONNECT3) {
                                        payLoad_ENVIRONMENTAL = payLoad99;
                                    }

                                    if(state==CONNECT4) {
                                        payLoad_ENVIRONMENTAL = payLoad99;
                                    }

                                    if(state==CONNECT6){    //connect environmental in the other channel
                                        payLoad_ENVIRONMENTAL = payLoad6;
                                        Log.e(LOG_TAG, "CONNECT 6");
                                    }

                                    if(state==SYNCHRONIZATION_RESUME)
                                    {
                                        payLoad_ENVIRONMENTAL = payLoad7;
                                    }

                                    if(state==RECONNECTION)
                                    {
                                        payLoad_ENVIRONMENTAL = payLoad7;
                                    }

                                    if(state==START)
                                    {
                                        payLoad_ENVIRONMENTAL = payLoad7;
                                        //save time to show
                                        /*SimpleDateFormat formatStartRec=new SimpleDateFormat("dd:MM:HH:mm:ss:SSS", Locale.getDefault());
                                        startrec_time=formatStartRec.format(new Date().getTime());
                                        Log.e("start","New rec: "+ startrec_time);*/
                                    }

                                    if(state==CALL1) {
                                        payLoad_ENVIRONMENTAL = payLoad16;
                                    }

                                    if(state==CALL2) {
                                        payLoad_ENVIRONMENTAL = payLoad16;
                                    }

                                    if(state==CALL3) {
                                        payLoad_ENVIRONMENTAL = payLoad16;
                                    }

                                    if(state==CALL4) {
                                        payLoad_ENVIRONMENTAL = payLoad16;
                                    }

                                    if(state==CALIBRATION) {
                                        payLoad_ENVIRONMENTAL = payLoad8;
                                    }

                                    if(state==STOP) {
                                        //stop the channel sending the payload9
                                        payLoad_ENVIRONMENTAL = payLoad9;
                                        //stop geolocalization update service
                                        fusedLocationClient.removeLocationUpdates(locationCallback);
                                    }

                                    //send the message through a specific payload
                                    try {
                                        antChannelENVIRONMENTAL.setBroadcastData(payLoad_ENVIRONMENTAL);
                                    } catch (RemoteException e) {
                                        e.printStackTrace();
                                    }

                                    //qua non metto variazione degli stati perchè non serve
                                }
                            }
                            else{
                                //Log.e(LOG_TAG, "Ant Service is bound: "+ serviceIsBound);
                            }

                            break;
                        case TRANSFER_RX_FAILED:
                            break;
                        case TRANSFER_TX_COMPLETED:
                            break;
                        case TRANSFER_TX_FAILED:
                            break;
                        case CHANNEL_CLOSED:
                            break;
                        case RX_FAIL_GO_TO_SEARCH:
                            break;
                        case CHANNEL_COLLISION:
                            break;
                        case TRANSFER_TX_START:
                            break;
                        case UNKNOWN:
                            break;
                    }
                    break;
            }
        };

        @Override
        public void onChannelDeath()
        {
            antDisconnection(IMUs_Saturation_Environmental.this);
        };
    };

    private ServiceConnection mAntRadioServiceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            mAntRadioService = new AntService(iBinder);
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {

            antDisconnection(IMUs_Saturation_Environmental.this);
        }
    };


    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.idicon:
                openDrawer(drawerLayout);
                break;

            case R.id.arrowback:
                closeDrawer(drawerLayout);
                break;

            case R.id.drawer_home:
                flag_home=true;
                endRecording(IMUs_Saturation_Environmental.this,PatientsList.class);
                break;

            case R.id.drawer_support:
                flag_support =true;
                endRecording(IMUs_Saturation_Environmental.this, Support.class);
                break;

            case R.id.drawer_logout:
                flag_logout=true;
                endRecording(IMUs_Saturation_Environmental.this,PatientsList.class);
                break;

            case R.id.drawer_closeapp:
                flag_closeapp=true;
                endRecording(IMUs_Saturation_Environmental.this,PatientsList.class);
                break;

            case R.id.helpbutton:
                GlobalVariables.flag_help_demodownload=true;
                MessageDialog messageDialog =new MessageDialog();
                messageDialog.show(getSupportFragmentManager(),"help messageDialog");
                break;

            case R.id.telephone:
                telephone(this);
                break;

            case R.id.storage:
                //open archive dialog
                dialogDownloadStorage();
                break;

            case R.id.update_storage_files:
                //to update close and reopen it
                dialogDownloadStorage.dismiss();
                dialogDownloadStorage();
                break;

            case R.id.cancel_storage_files:
                dialogDownloadStorage.dismiss();
                break;

            case R.id.initializationbutton:
                //show progressbar
                progressbar_initialization.setVisibility(View.VISIBLE);
                //change title on initialization started
                status_initialization.setText("Initialization started");
                //hide the button
                initializationbutton.setVisibility(View.GONE);

                try {
                    antChannelProvider = mAntRadioService.getChannelProvider();
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Ant Channel Provider is " + antChannelProvider);


                //channels available
                int channels=0;
                try {
                    channels=antChannelProvider.getNumChannelsAvailable();
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Ant Channels available " + channels);

                if(channels==0){
                    //display some error text
                    status_initialization.setText("Go back and retry initialization");
                    Toast.makeText(getApplicationContext(), "ERROR\n\nThe communication does not work correctly\n\nPress back button, go back and retry", Toast.LENGTH_LONG).show();
                    break;
                }

                try {
                    antChannelIMUs = antChannelProvider.acquireChannel(this, PredefinedNetwork.PUBLIC);
                } catch (ChannelNotAvailableException | RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Ant Channel IMUs: "+ antChannelIMUs);

                try {
                    antChannelIMUs.setChannelEventHandler(eventCallBack);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Event handler" + eventCallBack);

                try {
                    antChannelIMUs.assign(ChannelType.SHARED_BIDIRECTIONAL_MASTER);//SHARED_BIDIRECTIONAL_MASTER, 48=0x30

                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Channel is a SHARED_BIDIRECTIONAL_MASTER");

                try {
                    antChannelIMUs.setChannelId(channelId_smartphone_IMUs);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "" + channelId_smartphone_IMUs);

                try {
                    antChannelIMUs.setPeriod(USER_PERIOD_SENSORS);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "User period is:" + USER_PERIOD_SENSORS);

                try {
                    antChannelIMUs.setRfFrequency(USER_RADIOFREQUENCY);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "User radiofrequency is:" + USER_RADIOFREQUENCY);

                try {
                    antChannelIMUs.setTransmitPower(3);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Transmit power is 3");

                try {
                    antChannelIMUs.open();
                    mIsOpen_IMUs = true;
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Channel is open");
// CANALE ENVIRONMENTAL
                //channels available
                channels=0;
                try {
                    channels=antChannelProvider.getNumChannelsAvailable();
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Ant Channels available " + channels);

                if(channels==0){
                    //display some error text
                    status_initialization.setText("Go back and retry initialization");
                    Toast.makeText(getApplicationContext(), "ERROR\n\nThe communication does not work correctly\n\nPress back button, go back and retry", Toast.LENGTH_LONG).show();
                    break;
                }

                try {
                    antChannelENVIRONMENTAL = antChannelProvider.acquireChannel(this, PredefinedNetwork.PUBLIC);
                } catch (ChannelNotAvailableException | RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Ant Channel ENVIRONMENTAL: "+ antChannelENVIRONMENTAL);

                try {
                    antChannelENVIRONMENTAL.setChannelEventHandler(eventCallBack);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Event handler" + eventCallBack);

                try {
                    antChannelENVIRONMENTAL.assign(ChannelType.BIDIRECTIONAL_MASTER);

                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Channel is a BIDIRECTIONAL_MASTER");

                try {
                    antChannelENVIRONMENTAL.setChannelId(channelId_smartphone_ENVIRONMENTAL);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "" + channelId_smartphone_ENVIRONMENTAL);

                try {
                    antChannelENVIRONMENTAL.setPeriod(USER_PERIOD_ENVIRONMENTAL);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "User period is:" + USER_PERIOD_ENVIRONMENTAL);

                try {
                    antChannelENVIRONMENTAL.setRfFrequency(USER_RADIOFREQUENCY);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "User radiofrequency is:" + USER_RADIOFREQUENCY);

                try {
                    antChannelENVIRONMENTAL.setTransmitPower(3);
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Transmit power is 3");

                try {
                    antChannelENVIRONMENTAL.open();
                    mIsOpen_ENVIRONMENTAL = true;
                } catch (RemoteException | AntCommandFailedException e) {
                    e.printStackTrace();
                }
                Log.e(LOG_TAG, "Channel is open");

                state = CONNECT1;

                if(mIsOpen_IMUs && mIsOpen_ENVIRONMENTAL){
                    //if the channel is open
                    progressbar_initialization.setVisibility(View.GONE);
                    initializationbutton.setVisibility(View.GONE);

                    //change text,add checkmark and show gotoswitchonsensorsbutton
                    status_initialization.setText("Initialization successful!");
                    initialization_checkmark.setVisibility(View.VISIBLE);
                    bottom_initialization.setVisibility(View.VISIBLE);
                    gotoswitchonsensors.setVisibility(View.VISIBLE);
                }
                else{
                    antDisconnection(IMUs_Saturation_Environmental.this);

                    //display some error text
                    status_initialization.setText("Go back and retry initialization");
                    Toast.makeText(getApplicationContext(), "ERROR:\n\nThe communication does not work correctly\n\nPress back button, go back and retry", Toast.LENGTH_LONG).show();
                    //break;
                }
                break;

            case R.id.gotoswitchonsensors:

                inflated_initialization.setVisibility(View.GONE);

                viewStub = (ViewStub) findViewById(R.id.switchonsensors_toinclude);
                viewStub.setLayoutResource(R.layout.switch_on_imus_saturation_environmental);
                inflated_switch_on_sensors = viewStub.inflate();

                progressbar_idpatient.setVisibility(View.VISIBLE);

                switchonsensor1_checkmark=(ImageButton) findViewById(R.id.switchonsensor1_checkmark);
                switchonsensor2_checkmark=(ImageButton) findViewById(R.id.switchonsensor2_checkmark);
                switchonsensor3_checkmark=(ImageButton) findViewById(R.id.switchonsensor3_checkmark);
                switchonsensor4_checkmark=(ImageButton) findViewById(R.id.switchonsensor4_checkmark);
                switchonsensor6_checkmark=(ImageButton) findViewById(R.id.switchonsensor5_checkmark);

                switchonsensor1_progressbar=(ProgressBar) findViewById(R.id.switchonsensor1_progressbar);
                switchonsensor2_progressbar=(ProgressBar) findViewById(R.id.switchonsensor2_progressbar);
                switchonsensor3_progressbar=(ProgressBar) findViewById(R.id.switchonsensor3_progressbar);
                switchonsensor4_progressbar=(ProgressBar) findViewById(R.id.switchonsensor4_progressbar);
                switchonsensor6_progressbar=(ProgressBar) findViewById(R.id.switchonsensor5_progressbar);

                switchonsensor1=(TextView) findViewById(R.id.switchonsensor1);
                switchonsensor2=(TextView) findViewById(R.id.switchonsensor2);
                switchonsensor3=(TextView) findViewById(R.id.switchonsensor3);
                switchonsensor4=(TextView) findViewById(R.id.switchonsensor4);
                switchonsensor6=(TextView) findViewById(R.id.switchonsensor5);

                gotorecordingbutton=(Button) findViewById(R.id.gotorecordingbutton);
                gotorecordingbutton.setOnClickListener(this);

                break;

            case R.id.gotorecordingbutton:

                inflated_switch_on_sensors.setVisibility(View.GONE);

                viewStub = (ViewStub) findViewById(R.id.select_recording_toinclude);
                viewStub.setLayoutResource(R.layout.select_recording_general);
                inflated_select_recording = viewStub.inflate();

                timerrecordingbutton=(Button) findViewById(R.id.timerrecordingbutton);
                timerrecordingbutton.setOnClickListener(this);

                manualrecordingbutton=(Button) findViewById(R.id.manualrecordingbutton);
                manualrecordingbutton.setOnClickListener(this);

                layout_insert_setinforec =(TextInputLayout) findViewById(R.id.layout_insert_setinforec);

                insert_setinforec =(TextInputEditText) findViewById(R.id.insert_setinforec);

                clickhereforcalibration=(TextView) findViewById((R.id.clickhereforcalibration));
                clickhereforcalibration.setOnClickListener(this);

                break;

            case R.id.timerrecordingbutton:

                //get recording info
                GlobalVariables.string_setinforec = insert_setinforec.getText().toString();
                Log.e("demo",GlobalVariables.string_setinforec);

                inflated_select_recording.setVisibility(View.GONE);

                //check if it's the first time we enter to inflate the new elements correctly
                //the following time we only set visibility as in else statement
                if(!flag_timer_rec){

                    viewStub = (ViewStub) findViewById(R.id.timer_recording_toinclude);
                    viewStub.setLayoutResource(R.layout.timer_recording_general);
                    inflated_timer_rec = viewStub.inflate();

                    startrecording_timer=(Button) findViewById(R.id.startrecording_timer);
                    startrecording_timer.setOnClickListener(this);

                    timer_recording_filename=(TextView) findViewById(R.id.timer_recording_filename);
                    timer_recording_filename.setVisibility(View.GONE);

                    stoprecording_timer=(Button) findViewById(R.id.stoprecording_timer);
                    stoprecording_timer.setOnClickListener(this);

                    downloadfile_timer=(Button) findViewById(R.id.downloadfile_timer);
                    downloadfile_timer.setOnClickListener(this);

                    gotonewrecording_timer=(Button) findViewById(R.id.gotonewrecording_timer);
                    gotonewrecording_timer.setOnClickListener(this);

//showvaluesonmaps_timer = (Button) findViewById(R.id.show_values_on_maps_timer);
//showvaluesonmaps_timer.setOnClickListener(this);

                    goback_timer=(Button) findViewById(R.id.goback_timer);
                    goback_timer.setOnClickListener(this);

                    progressBar_timer=(ProgressBar) findViewById(R.id.progressbar_timer);

                    status_timer=(TextView) findViewById(R.id.status_timer);

                    timer=(TextView) findViewById(R.id.timer);

                    layout_insert_setduration=(TextInputLayout) findViewById(R.id.layout_insert_setduration);

                    insert_setduration=(TextInputEditText) findViewById(R.id.insert_setduration);

                    //raising the flag we avid to inflate it again causing an error and we show it again on next request
                    flag_timer_rec=true;
                }
                else{
                    inflated_timer_rec.setVisibility(View.VISIBLE);
                    //initialize the visibility of the views
                    //timerRecInitViews();

                    downloadfile_timer.setVisibility(View.GONE);
                    gotonewrecording_timer.setVisibility(View.GONE);
//showvaluesonmaps_timer.setVisibility(View.GONE);

                    status_timer.setVisibility(View.GONE);
                    timer_recording_filename.setVisibility(View.GONE);

                    layout_insert_setduration.setVisibility(View.VISIBLE);
                    insert_setduration.setVisibility(View.VISIBLE);
                    startrecording_timer.setVisibility(View.VISIBLE);
                    goback_timer.setVisibility(View.VISIBLE);
                }

                break;

            case R.id.startrecording_timer:

                //set timer duration
                String setduration=insert_setduration.getText().toString().trim();

                if(setduration.isEmpty()){
                    insert_setduration.setError("Required field");
                    insert_setduration.requestFocus();
                    return;
                }

                final int value_timer=(Integer.valueOf(setduration));
                int minutes_timer=value_timer*60;

                if(value_timer>600 || value_timer==0){
                    insert_setduration.setError("Minutes should be between 1 and 600");
                    insert_setduration.requestFocus();
                    return;
                }

                long duration= TimeUnit.SECONDS.toMillis(minutes_timer);

                layout_insert_setduration.setVisibility(View.GONE);
                insert_setduration.setVisibility(View.GONE);

                timer.setVisibility(View.VISIBLE);
                status_timer.setVisibility(View.VISIBLE);

                startrecording_timer.setVisibility(View.GONE);
                goback_timer.setVisibility(View.GONE);
                progressBar_timer.setVisibility(View.VISIBLE);
                status_timer.setText("Recording data...");

                stoprecording_timer.setVisibility(View.VISIBLE);
                downloadfile_timer.setVisibility(View.GONE);

                //delete update info
                old_inforecordingtext="";
                inforecording.setText(null);
                //show update info layout
                inflated_updateinfo.setVisibility(View.VISIBLE);
                inflated_displaydata.setVisibility(View.VISIBLE);

                //start recording ANT data
                state=START;

                //make a delay and then show the title
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        //show filename while recording
                        timer_recording_filename.setText("File: " + GlobalVariables.string_idpatient + " - " + startrec_time); //OR GlobalVariables.setCurrentTimeFile
                        timer_recording_filename.setVisibility(View.VISIBLE);
                    }
                }, 200 ); //500


                //initialize countdowntimer duration
                countDownTimer=new CountDownTimer(duration,1000){
                    @Override
                    public void onTick(long millisUntilFinished) {
                        //when tick, convert millisecond to minute and second
                        String sDuration=String.format(Locale.ENGLISH,"%02d : %02d"
                                ,TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished)
                                ,TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) -
                                        TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished)));

                        //set value on text view
                        timer.setText(sDuration);
                    }

                    @Override
                    public void onFinish() {
                        //when finish
                        countDownTimer.cancel();
                        timer.setVisibility(View.GONE);
                        progressBar_timer.setVisibility(View.GONE);
                        downloadfile_timer.setVisibility(View.VISIBLE);
                        status_timer.setText("Duration: " + value_timer +" min");
                        stoprecording_timer.setVisibility(View.GONE);

                        gotonewrecording_timer.setVisibility(View.VISIBLE);
//showvaluesonmaps_timer.setVisibility(View.VISIBLE);

                        //hide update info layout
                        inflated_updateinfo.setVisibility(View.GONE);
                        inflated_displaydata.setVisibility(View.GONE);

                        antStop();

                        //REMOVE WARNINGS DISCONNECTION and KEEP SHOWN THE CHECKMARK AND LOW BATTERY WARNING in case
                        exclamation_point_idpatient.setVisibility(View.GONE);
                        progressbar_idpatient.setVisibility(View.GONE);

                        sendNotification(IMUs_Saturation_Environmental.this,"Timer","Recording is finished!");
                    }
                }.start();

                break;

            case R.id.goback_timer:
                inflated_timer_rec.setVisibility(View.GONE);
                Log.e("demo","timer rec removed");
                inflated_select_recording.setVisibility(View.VISIBLE);
                break;

            case R.id.stoprecording_timer:

                //initialize alert dialog
                AlertDialog.Builder builder = new AlertDialog.Builder(IMUs_Saturation_Environmental.this);
                //set title
                builder.setTitle("Stop recording");
                //set message
                builder.setMessage("Are you sure you want to stop the recording?");
                //Positive yes button
                builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                        antStop();

                        //REMOVE WARNINGS DISCONNECTION and KEEP SHOWN THE CHECKMARK AND LOW BATTERY WARNING in case
                        exclamation_point_idpatient.setVisibility(View.GONE);
                        progressbar_idpatient.setVisibility(View.GONE);

                        countDownTimer.cancel();
                        timer.setVisibility(View.GONE);
                        progressBar_timer.setVisibility(View.GONE);
                        //startrecording_timer.setText("Start new recording");
                        //startrecording_timer.setVisibility(View.VISIBLE);

                        status_timer.setVisibility(View.GONE);
                        stoprecording_timer.setVisibility(View.GONE);
                        //layout_insert_setduration.setVisibility(View.VISIBLE);
                        //insert_setduration.setVisibility(View.VISIBLE);

                        downloadfile_timer.setVisibility(View.VISIBLE);
                        gotonewrecording_timer.setVisibility(View.VISIBLE);
//showvaluesonmaps_timer.setVisibility(View.VISIBLE);
                        //hide update info layout
                        inflated_updateinfo.setVisibility(View.GONE);
                        inflated_displaydata.setVisibility(View.GONE);

                        //azzerare variabili di mostra dati
                        temperature_output.setText("");
                        humidity_output.setText("");
                        pressure_output.setText("");
                        CO2_output.setText("");
                        VOC_output.setText("");
                        NO2_output.setText("");
                        CO_output.setText("");
                        PM1p0_output.setText("");
                        PM2p5_output.setText("");
                        PM10_output.setText("");
                    }
                });
                //negative no button
                builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //dismiss dialog
                        dialog.dismiss();
                    }
                });
                //show dialog
                builder.show();

                break;

            case R.id.downloadfile_timer:
                //if the flag_filetoosmall is raised avoid downloading the file
                if(flag_filetoosmall){
                    Toast.makeText(getApplicationContext(), "The file is too small and you can NOT downloading it", Toast.LENGTH_LONG).show();
                }else{
                    //call download function
                    download();
                }
                break;

            case R.id.gotonewrecording_timer:
                gotonewrecording(inflated_timer_rec);
                break;

            case R.id.manualrecordingbutton:

                //get recording info
                GlobalVariables.string_setinforec = insert_setinforec.getText().toString();
                Log.e("demo",GlobalVariables.string_setinforec);

                inflated_select_recording.setVisibility(View.GONE);

                //check if it's the first time we enter to inflate the new elements correctly
                //the following time we only set visibility as in else statement
                if(!flag_manual_rec){

                    viewStub = (ViewStub) findViewById(R.id.manual_recording_toinclude);
                    viewStub.setLayoutResource(R.layout.manual_recording_general);
                    inflated_manual_rec = viewStub.inflate();

                    startrecording_manual=(Button) findViewById(R.id.startrecording_manual);
                    startrecording_manual.setOnClickListener(this);

                    manual_recording_filename=(TextView) findViewById(R.id.manual_recording_filename);
                    manual_recording_filename.setVisibility(View.GONE);

                    stoprecording_manual=(Button) findViewById(R.id.stoprecording_manual);
                    stoprecording_manual.setOnClickListener(this);

                    downloadfile_manual=(Button) findViewById(R.id.downloadfile_manual);
                    downloadfile_manual.setOnClickListener(this);

                    gotonewrecording_manual=(Button) findViewById(R.id.gotonewrecording_manual);
                    gotonewrecording_manual.setOnClickListener(this);

//showvaluesonmaps_manual = (Button) findViewById(R.id.show_values_on_maps_manual);
//showvaluesonmaps_manual.setOnClickListener(this);

                    goback_manual=(Button) findViewById(R.id.goback_manual);
                    goback_manual.setOnClickListener(this);

                    progressBar_manual=(ProgressBar) findViewById(R.id.progressbar_manual);

                    status_manual=(TextView) findViewById(R.id.status_manual);

                    chronometer = findViewById(R.id.chronometer);
                    //chronometer.setFormat("Duration: %s");
                    chronometer.setBase(SystemClock.elapsedRealtime());

                    //raising the flag we avid to inflate it again causing an error and we show it again on next request
                    flag_manual_rec=true;

                }
                else{
                    inflated_manual_rec.setVisibility(View.VISIBLE);
                    //initialize the visibility of the views
                    //manualRecInitViews();

                    chronometer.setVisibility(View.GONE);
                    status_manual.setVisibility(View.GONE);
                    downloadfile_manual.setVisibility(View.GONE);
                    gotonewrecording_manual.setVisibility(View.GONE);
//showvaluesonmaps_manual.setVisibility(View.GONE);

                    manual_recording_filename.setVisibility(View.GONE);

                    startrecording_manual.setVisibility(View.VISIBLE);
                    goback_manual.setVisibility(View.VISIBLE);
                }

                break;

            case R.id.startrecording_manual:
                //Toast.makeText(this, "Recording is started", Toast.LENGTH_SHORT).show();
                startrecording_manual.setVisibility(View.GONE);
                goback_manual.setVisibility(View.GONE);

                progressBar_manual.setVisibility(View.VISIBLE);
                status_manual.setText("Recording data...");

                stoprecording_manual.setVisibility(View.VISIBLE);
                downloadfile_manual.setVisibility(View.GONE);

                chronometer.setBase(SystemClock.elapsedRealtime());
                chronometer.setVisibility(View.VISIBLE);
                chronometer.start();

                //delete update info
                old_inforecordingtext="";
                inforecording.setText(null);
                //show update info layout
                inflated_updateinfo.setVisibility(View.VISIBLE);
                inflated_displaydata.setVisibility(View.VISIBLE);

                //start recording ANT data
                state=START;

                //make a delay and then show the title
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        //show filename while recording
                        manual_recording_filename.setText("File: " + GlobalVariables.string_idpatient + " - " + startrec_time); //OR GlobalVariables.setCurrentTimeFile
                        manual_recording_filename.setVisibility(View.VISIBLE);
                    }
                }, 200 ); //500

                break;

            case R.id.goback_manual:
                inflated_manual_rec.setVisibility(View.GONE);
                Log.e("demo","manual rec removed");
                inflated_select_recording.setVisibility(View.VISIBLE);
                break;

            case R.id.stoprecording_manual:

                //initialize alert dialog
                AlertDialog.Builder builder_manual = new AlertDialog.Builder(IMUs_Saturation_Environmental.this);
                //set title
                builder_manual.setTitle("Stop recording");
                //set message
                builder_manual.setMessage("Are you sure you want to stop the recording?");
                //Positive yes button
                builder_manual.setPositiveButton("YES", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                        antStop();

                        //REMOVE WARNINGS DISCONNECTION and KEEP SHOWN THE CHECKMARK AND LOW BATTERY WARNING in case
                        exclamation_point_idpatient.setVisibility(View.GONE);
                        progressbar_idpatient.setVisibility(View.GONE);

                        chronometer.stop();

                        int timeElapsed = (int)(SystemClock.elapsedRealtime()-chronometer.getBase());

                        int minutes = (int) (timeElapsed) / 60000;
                        int seconds = (int) (timeElapsed - minutes * 60000) / 1000;

                        status_manual.setText("Recording finished");

                        progressBar_manual.setVisibility(View.GONE);
                        stoprecording_manual.setVisibility(View.GONE);

                        //startrecording_manual.setText("Start new recording"); //NO, go to initialization
                        //startrecording_manual.setVisibility(View.VISIBLE);
                        downloadfile_manual.setVisibility(View.VISIBLE);
                        gotonewrecording_manual.setVisibility(View.VISIBLE);
//showvaluesonmaps_manual.setVisibility(View.VISIBLE);

                        //hide update info layout
                        inflated_updateinfo.setVisibility(View.GONE);
                        inflated_displaydata.setVisibility(View.GONE);

                        //azzerare variabili di mostra dati
                        temperature_output.setText("");
                        humidity_output.setText("");
                        pressure_output.setText("");
                        CO2_output.setText("");
                        VOC_output.setText("");
                        NO2_output.setText("");
                        CO_output.setText("");
                        PM1p0_output.setText("");
                        PM2p5_output.setText("");
                        PM10_output.setText("");
                    }
                });
                //negative no button
                builder_manual.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //dismiss dialog
                        dialog.dismiss();
                    }
                });
                //show dialog
                builder_manual.show();

                break;

            case R.id.downloadfile_manual:
                //if the flag_filetoosmall is raised avoid downloading the file
                if(flag_filetoosmall){      //mettere == true
                    Toast.makeText(getApplicationContext(), "The file is too small and you can NOT downloading it", Toast.LENGTH_LONG).show();
                }else{
                    //call download function
                    download();
                }
                break;

            case R.id.gotonewrecording_manual:
                gotonewrecording(inflated_manual_rec);
                break;

            case R.id.updateinfo:
                posture=savePosture();
                updateInfo();
                break;

            case R.id.clickhereforcalibration:
                //dialog to enter
                //initialize alert dialog
                AlertDialog.Builder builder_cal = new AlertDialog.Builder(IMUs_Saturation_Environmental.this);
                //set title
                builder_cal.setTitle("Enter calibration");
                //set message
                builder_cal.setMessage("Are you sure to enter in calibration mode?\n\nOnce you entered you have to complete all the calibration steps before going back again.");
                //Positive yes button
                builder_cal.setPositiveButton("YES", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //get recording info
                        GlobalVariables.string_setinforec = insert_setinforec.getText().toString();
                        //Log.e("demo",GlobalVariables.string_addinforec);

                        //start CALIBRATION ANT data
                        state=CALIBRATION;

                        inflated_select_recording.setVisibility(View.GONE);

                        viewStub = (ViewStub) findViewById(R.id.calibration_toinclude);
                        viewStub.setLayoutResource(R.layout.calibration);
                        inflated_calibration = viewStub.inflate();

                        endcalibration_button=(Button) findViewById(R.id.endcalibration_button);
                        endcalibration_button.setOnClickListener(IMUs_Saturation_Environmental.this);
                    }
                });
                //negative no button
                builder_cal.setNegativeButton("NO", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //dismiss dialog
                        dialog.dismiss();
                    }
                });
                //show dialog
                builder_cal.show();

                break;

            case R.id.endcalibration_button:
                endCalibration(this);
                break;

            case R.id.lowbattery_idpatient:
                changeBatteriesWarning(IMUs_Saturation_Environmental.this);
                break;

            case R.id.exclamation_point_idpatient:
                sensorsDisconnection(this);
                break;

            case R.id.checkmark_idpatient:
                Toast.makeText(getApplicationContext(), "GOOD\n\nCommunication and sensors work great!", Toast.LENGTH_SHORT).show();
                break;
        }
    }

    //TODO-- drawer
    private static void openDrawer(DrawerLayout drawerLayout) {
        //open drawer layout
        drawerLayout.openDrawer(GravityCompat.START);
    }

    private static void closeDrawer (DrawerLayout drawerLayout){
        //close drawer layout
        //check condition
        if(drawerLayout.isDrawerOpen(GravityCompat.START)){
            //when drawer is open, close drawer
            drawerLayout.closeDrawer(GravityCompat.START);
        }
    }

    private void logout(final Activity activity) {
        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("Logout");
        //set message
        builder.setMessage("Are you sure?");
        //Positive yes button
        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //save preferences
                SharedPreferences preferences=getSharedPreferences("checkbox",MODE_PRIVATE);
                SharedPreferences.Editor editor= preferences.edit();
                editor.putString("keepmeloggedin","false");
                editor.apply();

                //firebase log out
                FirebaseAuth.getInstance().signOut();
                //finish activity
                activity.finishAffinity();
                //go to login page
                redirectActivity(IMUs_Saturation_Environmental.this, Login.class);
            }
        });
        //negative no button
        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
                //in any case we arrive here after we end the recording, so go to the patients list activity
                redirectActivity(IMUs_Saturation_Environmental.this, PatientsList.class);
            }
        });
        //show dialog
        builder.show();
    }

    private static void redirectActivity(Activity activity,Class aClass) {
        //initialize intent
        Intent intent= new Intent (activity,aClass);
        //set flag
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        //Start activity
        activity.startActivity(intent);
    }

    @Override
    protected void onPause() {
        super.onPause();
        //close drawer
        closeDrawer(drawerLayout);
    }

    private void closeApp (final Activity activity){
        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("RespirHò");
        //set message
        builder.setMessage("Are you sure you want to close this App?");
        //Positive yes button
        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //close the app
                activity.finishAffinity();
                android.os.Process.killProcess(android.os.Process.myPid());
                System.exit(1);
            }
        });
        //negative no button
        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
                //in any case we arrive here after we end the recording, so go to the patients list activity
                redirectActivity(IMUs_Saturation_Environmental.this, PatientsList.class);
            }
        });
        //show dialog
        builder.show();
    }
    //TODO-- END drawer

    private void telephone(final Activity activity){
        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("Telephone");

        if(GlobalVariables.string_telephonepatient !=null && !GlobalVariables.string_telephonepatient.isEmpty()){
            builder.setMessage(GlobalVariables.string_telephonepatient);
        }
        else {
            builder.setMessage("Telephone number not added");
        }

        //call button
        builder.setPositiveButton("CALL", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //OPEN TELEPHONE
                Intent intent=new Intent(Intent.ACTION_DIAL);
                intent.setData(Uri.parse("tel:"+GlobalVariables.string_telephonepatient));
                startActivity(intent);
            }
        });
        //close button
        builder.setNegativeButton("CLOSE", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }

    public void dialogDownloadStorage(){
        //initialize alert dialog
        dialogBuilder = new AlertDialog.Builder(this);
        final View storage_files=getLayoutInflater().inflate(R.layout.storagefiles_dialog,null);

        //load the list with the files in firebase storage
        updateDownloadStorage();

        //recycler view
        recyclerview_storage_files = (RecyclerView) storage_files.findViewById(R.id.recyclerView_storage_files);

        //add a line separator
        DividerItemDecoration itemDecor = new DividerItemDecoration(getApplicationContext(), HORIZONTAL);
        recyclerview_storage_files.addItemDecoration(itemDecor);
        recyclerview_storage_files.setHasFixedSize(true);
        layoutManager_storage_files=new LinearLayoutManager(this);
        adapter_storage_files=new Adapter_PatientData(item_storage_files);

        recyclerview_storage_files.setLayoutManager(layoutManager_storage_files);
        recyclerview_storage_files.setAdapter(adapter_storage_files);

        status_storage_files=(TextView) storage_files.findViewById(R.id.status_storage_files);

        progressbar_storage_files=(ProgressBar) storage_files.findViewById(R.id.progressbar_storage_files);
        progressbar_storage_files.setVisibility(View.VISIBLE);

        update_storage_files=(Button) storage_files.findViewById(R.id.update_storage_files);
        update_storage_files.setOnClickListener(this);

        cancel_storage_files=(Button) storage_files.findViewById(R.id.cancel_storage_files);
        cancel_storage_files.setOnClickListener(this);

        dialogBuilder.setView(storage_files);
        dialogDownloadStorage=dialogBuilder.create();
        dialogDownloadStorage.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        //dialogDownloadStorage.setCancelable(false);
        dialogDownloadStorage.show();

        //to change the UI we have to put codes in the runOnUiThread
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //function for the storage files
                adapter_storage_files.setOnItemClickListener(new Adapter_PatientData.OnItemClickListener() {

                    @Override
                    public void onDownloadFileClick(int position) {
                        downloadFileStorage(position);
                    }

                    @Override
                    public void onDeleteFileClick(int position) {
                        deleteFileStorage(IMUs_Saturation_Environmental.this,position);
                    }
                });
            }
        });
    }

    private void updateDownloadStorage(){

        //always clear the list and reload it
        item_storage_files=new ArrayList<>();

        mStorageRef= FirebaseStorage.getInstance().getReference("Patients").
                child(GlobalVariables.string_idpatient);

        mStorageRef.listAll().addOnSuccessListener(new OnSuccessListener<ListResult>() {
            @Override
            public void onSuccess(ListResult listResult) {

                for (StorageReference item : listResult.getItems()) {
                    //save the items in the recycler view
                    item_storage_files.add(new Item_StorageFiles(item.getName()));
                    adapter_storage_files.notifyDataSetChanged();
                }

                if(item_storage_files.isEmpty()){
                    status_storage_files.setVisibility(View.VISIBLE);
                    progressbar_storage_files.setVisibility(View.GONE);
                }
                else{
                    status_storage_files.setVisibility(View.GONE);
                    progressbar_storage_files.setVisibility(View.GONE);
                }
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                // Uh-oh, an error occurred!
                Log.e("demo","error");
                Toast.makeText(getApplicationContext(), "Error loading the files\n\nCheck internet connection", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void downloadFileStorage(int position) {

        String downloadFilename = item_storage_files.get(position).getFilename();

        mStorageRef = FirebaseStorage.getInstance().getReference("Patients").
                child(GlobalVariables.string_idpatient).child(downloadFilename);

        //ext storage
        File folderExt=createDirectory("respirho","Patients", GlobalVariables.string_idpatient, extPath);
        File fileExt=new File(folderExt,downloadFilename);

        progressbar_storage_files.setVisibility(View.VISIBLE);

        mStorageRef.getFile(fileExt).addOnSuccessListener(new OnSuccessListener<FileDownloadTask.TaskSnapshot>() {
            @Override
            public void onSuccess(FileDownloadTask.TaskSnapshot taskSnapshot) {
                progressbar_storage_files.setVisibility(View.GONE);
                Toast.makeText(getApplicationContext(), "File " + downloadFilename + " saved in:\n" + extPath + "/respirho/Patients", Toast.LENGTH_LONG).show();
                Log.e("demo","success");
            }
        }).addOnProgressListener(new OnProgressListener<FileDownloadTask.TaskSnapshot>() {
            @Override
            public void onProgress(@NonNull @NotNull FileDownloadTask.TaskSnapshot snapshot) {
                //Log.e("demo","progress");
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull @NotNull Exception e) {
                Toast.makeText(getApplicationContext(), "An error occurred while downloading the file\n\nCheck internet connection", Toast.LENGTH_SHORT).show();
                Log.e("demo","failure");
            }
        });
    }

    private void deleteFileStorage(Activity activity, int position){
        //AIM: move file to another folder on firebase storage (bin)
        //1. download the file internally
        //2. upload the file in the bin folder on firebase storage
        //3. delete the file on the original storage folder
        //4. delete the file internally
        //5. update the storage dialog

        Log.e("demo","1.");

        String deletedFilename = item_storage_files.get(position).getFilename();

        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("Delete file");
        //set message
        builder.setMessage("Are you sure you want to delete the following file?\n\nFile: " + deletedFilename);
        //Positive yes button
        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //1. download the file internally
                StorageReference deletedFileStorageRef = FirebaseStorage.getInstance().getReference("Patients").
                        child(GlobalVariables.string_idpatient).child(deletedFilename);

                //path where the root of the txt file will be located internally (NOT VISIBLE ON THE SMARTPHONE)
                File folderInt=new File(intPath);

                if(!folderInt.exists()){
                    folderInt.mkdir();
                }

                File deletedfileInt=new File(folderInt,deletedFilename);

                progressbar_storage_files.setVisibility(View.VISIBLE);

                deletedFileStorageRef.getFile(deletedfileInt).addOnSuccessListener(new OnSuccessListener<FileDownloadTask.TaskSnapshot>() {
                    @Override
                    public void onSuccess(FileDownloadTask.TaskSnapshot taskSnapshot) {
                        //2. upload the file in the bin folder on firebase storage
                        Log.e("demo","2.");

                        //get Uri needed to upload file on Firebase storage
                        Uri deletedFileUri=Uri.fromFile(deletedfileInt);

                        if(deletedFileUri!=null){
                            StorageReference binStorageRef=FirebaseStorage.getInstance().getReference("Bin").
                                    child(GlobalVariables.string_idpatient).child(deletedFilename);

                            StorageTask deletedFileUploadTask= binStorageRef.putFile(deletedFileUri);

                            deletedFileUploadTask.addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception exception) {
                                    // Handle unsuccessful uploads
                                    Log.e("saveFirebase", "ERROR:file not uploaded on Firebase");
                                }
                            }).addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
                                @Override
                                public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
                                    //3. delete the file on the original storage folder
                                    Log.e("demo","3.");

                                    deletedFileStorageRef.delete().addOnSuccessListener(new OnSuccessListener<Void>() {
                                        @Override
                                        public void onSuccess(Void aVoid) {
                                            //4. delete the file internally
                                            Log.e("demo","4.");
                                            deletedfileInt.delete();

                                            progressbar_storage_files.setVisibility(View.GONE);

                                            //5. update the storage dialog
                                            //to update close and reopen it
                                            dialogDownloadStorage.dismiss();
                                            dialogDownloadStorage();

                                            Toast.makeText(getApplicationContext(), deletedFilename + " has been deleted", Toast.LENGTH_SHORT).show();
                                        }
                                    }).addOnFailureListener(new OnFailureListener() {
                                        @Override
                                        public void onFailure(@NonNull Exception exception) {
                                            // Uh-oh, an error occurred!
                                        }
                                    });
                                }
                            });
                        }
                        Log.e("demo","success");
                    }
                }).addOnProgressListener(new OnProgressListener<FileDownloadTask.TaskSnapshot>() {
                    @Override
                    public void onProgress(@NonNull @NotNull FileDownloadTask.TaskSnapshot snapshot) {
                        Log.e("demo","progress");
                    }
                }).addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull @NotNull Exception e) {
                        Log.e("demo","failure");
                    }
                });
            }
        });
        //negative no button
        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }

    private File createDirectory(String dirName, String subDir,String subsubDir, String path){
        File rootfolder,subfolder,subsubfolder;

        rootfolder=new File(path + "/" + dirName);

        if(!rootfolder.exists()){
            rootfolder.mkdir();
        }

        subfolder=new File(rootfolder + "/" + subDir);

        if(!subfolder.exists()){
            subfolder.mkdir();
        }

        subsubfolder=new File(subfolder + "/" + subsubDir);

        if(!subsubfolder.exists()){
            subsubfolder.mkdir();
        }

        return subsubfolder;
    }

    private float convertToBattery(String messageContentString_battery){
        //convert the battery byte hex value in volt
        Float battery_value=null;
        float battery_float=Integer.parseInt(messageContentString_battery,16);
        battery_value=battery_float * 1881/69280;
        return battery_value;
    }

    private void changeBatteriesWarning(Activity activity) {
        String text_dead_batteries=dead_battery_unit1 + " " + dead_battery_unit2 + " " + dead_battery_unit3 + " " + dead_battery_unit4 + "" + dead_battery_unit6;

        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("Warning batteries sensors");
        //set message
        builder.setMessage("Change the batteries of the sensors unit:\n\n" + text_dead_batteries + "\n\nPress back button, go back and restart recording");
        //Positive yes button
        builder.setPositiveButton("CLOSE", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }

    private void endCalibration(final Activity activity){
        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("End calibration");
        //set message
        builder.setMessage("Are you sure you want to end calibration?\n\nDon't go back if the calibration is not completed.\nWait till the LEDs will turn off");
        //Positive yes button
        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //go to select recording layout
                inflated_calibration.setVisibility(View.GONE);
                inflated_select_recording.setVisibility(View.VISIBLE);
                state= SYNCHRONIZATION_RESUME;
            }
        });
        //negative no button
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }

    private void initializeNotification(String title) {
        if(Build.VERSION.SDK_INT>= Build.VERSION_CODES.O){
            NotificationChannel channel_not= new NotificationChannel(title,title, NotificationManager.IMPORTANCE_DEFAULT);

            //LIGHTS
            channel_not.enableLights(true);
            channel_not.setLightColor(Color.GREEN);

            NotificationManager manager=getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel_not);
        }
    }

    private void sendNotification(Activity activity, String title, String description){

        initializeNotification(title);

        NotificationCompat.Builder builder_not=new NotificationCompat.Builder(activity,title);
        builder_not.setContentTitle(title);
        builder_not.setContentText(description);
        builder_not.setSmallIcon(R.mipmap.ic_applogo_foreground);
        builder_not.setAutoCancel(true);
        builder_not.setTicker(title);

        //pattern vibration
        long [] patternVibration={0,500, 100, 500};

        Vibrator vibrator= (Vibrator) getSystemService(VIBRATOR_SERVICE);
        vibrator.vibrate(patternVibration,-1);

        NotificationManagerCompat managerCompat=NotificationManagerCompat.from(activity);
        managerCompat.notify(1,builder_not.build());
    }

    private String savePosture(){

        String pstr;
        int radioId = posture_buttons.getCheckedRadioButtonId();
        posture_selected = findViewById(radioId);
        pstr=posture_selected.getText().toString();

        if(pstr.equals(null)){
            pstr="None";
        }
        return pstr;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void updateInfo(){
        //save time to show
        SimpleDateFormat format=new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
        String time=format.format(new Date().getTime());

        //SET INFO POSTURE
        //compare old posture with the new one, if it's different, show it
        if(!oldposture.equals(posture)){
            inforecording.append("- Posture: " + posture + " (" + time + ")" + "\n");
        }

        Log.e("demo","oldposture: " + oldposture);
        Log.e("demo","posture: " + posture);

        //update oldposture
        oldposture=posture;

        //SET ADDITIONAL INFO
        String additionalinfo=insert_addinforec.getText().toString();

        //if it's not null, show info
        if(!TextUtils.isEmpty(additionalinfo)){
            Log.e("demo","addinfo:"+additionalinfo+"end");
            inforecording.append("- Additional info: " + additionalinfo + " (" + time + ")" + "\n");
        }

        //delete the text in addinforec
        insert_addinforec.setText(null);
    }

    private void download(){

        WritingDataToFile writingDataToFile = new WritingDataToFile();

        try {
            writingDataToFile.moveFileToExt(fileInt,day,extPath);
        } catch (IOException e) {
            e.printStackTrace();
        }

        //delete the file in to clear the space in case
        //writingDataToFile.deleteFileInt(fileInt);

        Toast.makeText(getApplicationContext(), "File saved in: " +extPath+ "/respirho/Patients/" + GlobalVariables.string_idpatient, Toast.LENGTH_LONG).show();
    }

    private void gotonewrecording(View current_inflater){
        //hide warnings
        checkmark_idpatient.setVisibility(View.GONE);
        lowbattery_idpatient.setVisibility(View.GONE);
        //initialize the variables of the batteries
        dead_battery_unit1="";
        dead_battery_unit2="";
        dead_battery_unit3="";
        dead_battery_unit4="";
        dead_battery_unit6="";
        //put the flag on to check the battery to display warning once
        flag_battery=true;

        //watchdog reset
        resetWatchdogTimer(UNIT1);
        resetWatchdogTimer(UNIT2);
        resetWatchdogTimer(UNIT3);
        resetWatchdogTimer(UNIT4);
        sumWt=0;
        //lower the flag
        flag_reconnection=false;
        //raise the flag
        flag_watchdog_timer_overflow = true;

        //initialize size_interval_backupfile for a new recording
        size_interval_backupfile=SIZE_INTERVAL_BACKUPFILE;

        //lower the flag to reset the name and the header of the file
        GlobalVariables.flag_fileexist=false;

        //if the flag of the sensors disconnection has been still raised, it means the recording is finished with still on or more sensors that don't work correctly
        //so avoid going to a new recording and force the user to repeat initialization
        if(flag_sensors_disconnection){
            //force the user to go back initialize again the sensors calling endRecording function
            //and just change the message in the dialog raising the following flag
            flag_home=true;
            flag_sensors_disconnection_header=true;
            endRecording(IMUs_Saturation_Environmental.this,PatientsList.class);
        }
        else{
            //go back setting the right visibility of the view previously inflated
            current_inflater.setVisibility(View.GONE);
            inflated_select_recording.setVisibility(View.VISIBLE);
            flag_filetoosmall=false;
        }
    }

    private void endRecording(final Activity current_activity, Class destination_class){
        String messagedialog="";
        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(current_activity);
        //set title
        builder.setTitle("End recording");
        //set message
        if(flag_sensors_disconnection_header){
            messagedialog=sensors_disconnection_header;
        }else{
            messagedialog="Are you sure you want to end recording?\n\nGoing back you have to initialize again communication and sensors\n\nIf yes, switch OFF the sensors";
        }
        builder.setMessage(messagedialog);
        //Positive yes button
        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //close the ANT channel
                antClose();
                //remove the warnings
                error_idpatient.setVisibility(View.GONE);
                exclamation_point_idpatient.setVisibility(View.GONE);
                progressbar_idpatient.setVisibility(View.GONE);
                lowbattery_idpatient.setVisibility(View.GONE);
                checkmark_idpatient.setVisibility(View.GONE);
                //initialize the variables of the batteries
                dead_battery_unit1="";
                dead_battery_unit2="";
                dead_battery_unit3="";
                dead_battery_unit4="";
                dead_battery_unit6="";

                flag_sensors_disconnection=false;
                flag_sensors_disconnection_header=false;

                flag_filetoosmall=false;

                if(flag_home){
                    redirectActivity(current_activity,destination_class);
                    flag_home=false;
                }
                else if(flag_support){
                    redirectActivity(current_activity,destination_class);
                    flag_support =false;
                }
                else if(flag_logout){
                    logout(IMUs_Saturation_Environmental.this);
                    flag_logout=false;
                }
                else if(flag_closeapp){
                    closeApp(IMUs_Saturation_Environmental.this);
                    flag_closeapp=false;
                }
            }
        });
        //negative no button
        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }

    public void antStop() {
        //stops the recording, in case resume it with a new recording, NOT close the channel
        state=STOP;
        // lower the flag to save the file internally in WritingDataToFile
        flag_stoprec=true;
        //make it null so the first time we access old_messageContentString is null, so we won't add any dummy messages
        old_messageContentString_unit=null;

        //initialize also the flag needed for the watchdog in case we stop the recording while the sensors are still disconnected
        flag_watchdog_timer_overflow = true;
        flag_reconnection = false;

        //initialize size_interval_backupfile for a new recording
        size_interval_backupfile=SIZE_INTERVAL_BACKUPFILE;

        //save file on firebase
        saveFileOnFirebase(fileInt);
    }

    public void saveFileOnFirebase(File fileInt){
        //check if fileInt exist and in case add the info recording and then save it to firebase
        if(fileInt.exists()){

            //add the info recording
            inforecordingtext=inforecording.getText().toString();
            //if the info recording is not empty...
            if(!TextUtils.isEmpty(inforecordingtext)){

                //if the old info recording is different from the info recording,
                if(!old_inforecordingtext.equals(inforecordingtext)){
                    Log.e("inforecording","inforecording is:\n" + inforecordingtext);
                    Log.e("inforecording","OLDinforecording is:\n" + old_inforecordingtext);
                    //delete the previous inforecordingtext and write the new one
                    try {
                        deleteInfoRecordingToFile(fileInt);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                    try {
                        addInfoRecordingToFile(fileInt, inforecordingtext);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                    old_inforecordingtext=inforecordingtext;
                }
            }

            //file size: more or less 2kb/sec   (100 kb =60 sec)(6 Mb = 1hour)
            //if the file is smaller than 6 kb (3 sec), avoid saving on Firebase and avoid downloading it with an alert saying it's too small
            long fileIntSizeBytes=fileInt.length();
            long fileIntSizeKyloBytes=fileIntSizeBytes/1024;

            if(fileIntSizeKyloBytes>6){
                //call the save firebase class to upload file on firebase
                SaveFileToFirebase saveFileToFirebase= new SaveFileToFirebase();
                saveFileToFirebase.mainFirebase(fileInt);
            }
            else{
                //smaller than 4kb so no save on firebase
                //TODO - add flag needed for the download button to display alert
                flag_filetoosmall=true;
                Log.e("saveFirebase", "ERROR:file smaller than the threshold");
            }
        }
        else{
            //smaller than 4kb so no save on firebase
            flag_filetoosmall=true;
            Log.e("saveFirebase", "FILE NOT EXIST");
        }
    }

    public void deleteInfoRecordingToFile(File file) throws IOException {
        File temp = File.createTempFile("temp-file-name", ".tmp");
        Log.e("demo","filetemp is: " + temp);
        String postureline="- Posture:"; //it must be the same string as the one written in the inforecordingtext
        String addrecordinginfoline="- Additional info:"; //it must be the same string as the one in the inforecordingtext

        BufferedReader br = new BufferedReader(new FileReader( file ));
        PrintWriter pw =  new PrintWriter(new FileWriter( temp ));
        String line;
        String emptyline="";
        while ((line = br.readLine()) != null) {

            if(line.contains(postureline)){
                pw.print(emptyline);
                Log.e("inforec","postureline: " + line);
            }
            else if(line.contains(addrecordinginfoline)){
                pw.print(emptyline);
                Log.e("inforec","addrecordinginfoline: " + line);
            }
            else{
                //print normally the others data
                pw.println(line);
            }
        }

        br.close();
        pw.close();
        file.delete();
        temp.renameTo(file);
        Log.e("demo","fileInt modified and saved");
    }

    public void addInfoRecordingToFile(File file, String text) throws IOException {
        File temp = File.createTempFile("temp-file-name", ".tmp");
        Log.e("demo","filetemp is: " + temp);
        String posturesandinfo="Real time postures and extra info recording:"; //it must be the same string as the one in the header of WritingDataToFirebase

        BufferedReader br = new BufferedReader(new FileReader( file ));
        PrintWriter pw =  new PrintWriter(new FileWriter( temp ));
        String line;
        while ((line = br.readLine()) != null) {
            pw.println(line);
            if(line.equals(posturesandinfo)){
                pw.println(text);
                Log.e("inforec","info rec added");
            }
        }
        br.close();
        pw.close();
        file.delete();
        temp.renameTo(file);
        Log.e("demo","fileInt modified and saved");
    }

    public void antClose() {

        state = CLOSE;
        // lower the flag to save the file internally in WritingDataToFile
        flag_stoprec=true;
        //lower the flag to reset the name and the header of the file
        GlobalVariables.flag_fileexist=false;
        //make it null so the first time we acces old_messageContentString is null, so we won't add any dummy messages
        old_messageContentString_unit=null;

        //initialize size_interval_backupfile for a new recording
        size_interval_backupfile=SIZE_INTERVAL_BACKUPFILE;

        if(mIsOpen_IMUs && mIsOpen_ENVIRONMENTAL){
            //close the channel
            try {
                antChannelIMUs.close();
            } catch (RemoteException e) {
                e.printStackTrace();
            } catch (AntCommandFailedException e) {
                e.printStackTrace();
            }
            mIsOpen_IMUs = false;
            Log.e(LOG_TAG, "mIsOpen_IMUs was true and now the Channel is closed");

            //close the channel
            try {
                antChannelENVIRONMENTAL.close();
            } catch (RemoteException e) {
                e.printStackTrace();
            } catch (AntCommandFailedException e) {
                e.printStackTrace();
            }
            mIsOpen_ENVIRONMENTAL = false;
            Log.e(LOG_TAG, "mIsOpen_Environmental was true and now the Channel is closed");
        }
    }

    private void antDisconnection(final Activity activity){

        //add error warning and dialog
        //to change the UI we have to put codes in the runOnUiThread
        runOnUiThread(new Runnable() {
            @Override
            public void run() {

                //stop the ant channel so it saves the fileInt on Firebase
                antStop();
                //close the ANT channel
                antClose();
                //initialize the variables of the batteries
                dead_battery_unit1="";
                dead_battery_unit2="";
                dead_battery_unit3="";
                dead_battery_unit4="";
                dead_battery_unit6="";

                //display error warning
                error_idpatient.setVisibility(View.VISIBLE);
                lowbattery_idpatient.setVisibility(View.GONE);
                exclamation_point_idpatient.setVisibility(View.GONE);
                progressbar_idpatient.setVisibility(View.GONE);
                checkmark_idpatient.setVisibility(View.GONE);

                //TODO- send notification
                sendNotification(IMUs_Saturation_Environmental.this,"Communication failed","Go back and restart acquisition");

                //check if the activity is not closing clicking back button to avoid crash trying to create the dialog
                if(!((Activity) activity).isFinishing())
                {
                    //initialize alert dialog
                    AlertDialog.Builder builder_ant_disconnection = new AlertDialog.Builder(activity);
                    //prevent clicking the back button to close it
                    builder_ant_disconnection.setCancelable(false);
                    //set title
                    builder_ant_disconnection.setTitle("ERROR");
                    //set message
                    builder_ant_disconnection.setMessage("The communication and/or more sensors don't work correctly\n\nSwitch OFF the sensors\n\nPress GO BACK button and retry");
                    //Positive yes button
                    builder_ant_disconnection.setPositiveButton("GO BACK", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                            //go to patient data layout calling the onBackPressed() with the state=QUIT_RECORDING
                            state=QUIT_RECORDING;
                            onBackPressed();
                        }
                    });
                    //show dialog
                    builder_ant_disconnection.show();
                }
            }
        });
    }

    private void sensorsDisconnection(final Activity activity){

        Log.e("sensorsDisconnection","sensorsDisconnection: " + watchdog_timer[UNIT1] + "-" + watchdog_timer[UNIT2] + "-" + watchdog_timer[UNIT3]+ "-" + watchdog_timer[UNIT4]);

        //check which sensor is disconnected
        if(watchdog_timer[UNIT1]>=10){
            sensorDisconnected1="1";
        }
        if(watchdog_timer[UNIT2]>=10){
            sensorDisconnected2="2";
        }
        if(watchdog_timer[UNIT3]>=10){
            sensorDisconnected3="3";
        }
        if(watchdog_timer[UNIT4]>=10){
            sensorDisconnected4="4";
        }

        sensorsDisconnectedText=sensorDisconnected1 + " " + sensorDisconnected2 + " " + sensorDisconnected3 + " " + sensorDisconnected4;

        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        //set title
        builder.setTitle("Sensors disconnected");
        //set message
        builder.setMessage("The following sensor units appear to be disconnected:\n\n" + sensorsDisconnectedText + "\n\nPlease, go closer to the sensors and wait till the green checkmark appears.\n\nOtherwise, switch OFF the sensors.\nPress GO BACK button and end recording");
        //Positive yes button
        builder.setPositiveButton("CLOSE", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }

    //watchdog timer start
    public void startWatchdogTimer(int unit){
        watchdog_timer[unit]++; //increase the i-unit wt
        //Log.e("w",unit+1 + " - " + watchdog_timer[unit]);
    }

    //watchdog timer reset
    public void resetWatchdogTimer(int unit){
        watchdog_timer[unit]=0; //reset the i-unit wt
        //if we come back from the RECONNECTION states it means now the sensors works
        //so we hide the exclamation point and show the green checkmark
        if(flag_reconnection && sumWt<40){
            Log.e("w","RESTORE CONNECTION");
            //raise the flag to enter eventually in the OVERFLOW if statement only once
            flag_watchdog_timer_overflow=true;
            //reset the wt the first time I reconnect
            watchdog_timer[UNIT1]=0;
            watchdog_timer[UNIT2]=0;
            watchdog_timer[UNIT3]=0;
            watchdog_timer[UNIT4]=0;
            sumWt=0;

            //reset the warnings
            sensorDisconnected1="";
            sensorDisconnected2="";
            sensorDisconnected3="";
            sensorDisconnected4="";

            //to change the UI we have to put codes in the runOnUiThread
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    exclamation_point_idpatient.setVisibility(View.GONE);
                    checkmark_idpatient.setVisibility(View.VISIBLE);

                    progressbar_idpatient.setVisibility(View.GONE);
                    flag_sensors_disconnection=false;
                }
            });
            //lower the flag to enter only once
            flag_reconnection=false;
        }
    }

    //watchdog timer check
    public void checkWatchdogTimer(){
        sumWt = watchdog_timer[UNIT1] + watchdog_timer[UNIT2] + watchdog_timer[UNIT3]+ watchdog_timer[UNIT4];
        //threshold set to 40, if only one unit does not work --> 4 sec, if all the three --> 1 sec
        if(sumWt > THRESHOLD_WATCHDOG_TIMER){
            //if the flag is true, execute the following lines to send warnings and notification
            if(flag_watchdog_timer_overflow && !flag_reconnection){
                //to change the UI we have to put codes in the runOnUiThread
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        exclamation_point_idpatient.setVisibility(View.VISIBLE);
                        checkmark_idpatient.setVisibility(View.GONE);

                        progressbar_idpatient.setVisibility(View.VISIBLE);
                        flag_sensors_disconnection=true; //save the state in which one of the sensors is disconnected

                        //send warning to the user (notification), tell to go closer to sensors and automatically sync the unit
                        sendNotification(IMUs_Saturation_Environmental.this,"Sensors disconnection","Go closer to the sensors");

                        //TODO- send SMS (now it works only with SIM)
                        //TODO- ask the number in logo page
                        //SmsManager smsManager = SmsManager.getDefault();
                        //smsManager.sendTextMessage("+393452887433", null, "sms message", null, null);

                        //do not set state=START because it sets start rec time and we don't want to set it since it's already set
                        //so manually send the same payload through state=RECONNECTION so automaticcaly it will call the other states recursively
                        state=RECONNECTION; //state=RECONNECTION;
                        flag_reconnection=true;
                    }
                });

                //lower the flag to enter in the if statement only once
                flag_watchdog_timer_overflow=false;

                Log.e("w","notif sent");
            }
        }
        //Log.e("w","sum w: " + sumWt );
    }

    //BACK BUTTON FUNCTIONS
    @Override
    public void onBackPressed() {
        //manage back button in some steps of the recording to ensure a safe quit of the recording
        if(state==CALIBRATION){
            endCalibration(IMUs_Saturation_Environmental.this);
            return;
        }

        if(show_maps_flag == true) {
            getSupportFragmentManager().beginTransaction().remove(mapFragment).commit();
            show_maps_flag = false;
        }

        if(state==QUIT_RECORDING){
            state= SYNCHRONIZATION_RESUME;
            super.onBackPressed();
            return;
        }

        //initialize alert dialog
        AlertDialog.Builder builder = new AlertDialog.Builder(IMUs_Saturation_Environmental.this);
        //set title
        builder.setTitle("End recording");
        //set message
        builder.setMessage("Are you sure you want to end recording?\n\nGoing back you have to initialize again communication and sensors\n\nIf YES, switch OFF the sensors.");
        //Positive yes button
        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //stop the channel, so in case it saves fileInt on Firebase
                antStop();
                //close the ANT channel
                antClose();
                //initialize the variables of the batteries
                dead_battery_unit1="";
                dead_battery_unit2="";
                dead_battery_unit3="";
                dead_battery_unit4="";
                dead_battery_unit6="";
                //go to patient data layout
                state=QUIT_RECORDING;
                //call again the onBackPressed() and in this way it enters in the previous if condition
                onBackPressed();
            }
        });
        //negative no button
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //dismiss dialog
                dialog.dismiss();
            }
        });
        //show dialog
        builder.show();
    }
}
