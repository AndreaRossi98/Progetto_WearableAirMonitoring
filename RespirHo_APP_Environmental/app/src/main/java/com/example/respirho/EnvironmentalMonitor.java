package com.example.respirho;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.IBinder;
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
import org.w3c.dom.Text;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;


public class EnvironmentalMonitor extends AppCompatActivity implements View.OnClickListener{

//VEDERE COSA SERVE DI TUTTO QUESTO
    private Button timerrecordingbutton,manualrecordingbutton,initializationbutton_environmental_monitor,gotoswitchonenvironmentalmonitor,gotorecordingbutton_pulse_ox;
    private Button startrecording_manual,stoprecording_manual,downloadfile_manual,gotonewrecording_manual,goback_manual;
    private Button startrecording_timer,stoprecording_timer,downloadfile_timer,gotonewrecording_timer,goback_timer;
    private Button endcalibration_button;
    private ImageButton initialization_checkmark,
            switchonpulseox_checkmark;

    private ProgressBar progressBar_manual, progressBar_timer,progressbar_initialization,
            switchonpulseox_progressbar,progressbar_idpatient;
    private TextView status_manual,status_timer,status_initialization,bottom_initialization,
            switch_on_pulseox,manual_recording_filename,timer_recording_filename;
    private TextView timer;
    private TextView clickhereforcalibration;
    private TextInputLayout layout_insert_setduration, layout_insert_setinforec;
    private TextInputEditText insert_setduration, insert_setinforec;
    private CountDownTimer countDownTimer;
    private Chronometer chronometer;
    private ViewStub viewStub;
    private View inflated_initialization,inflated_switch_on_sensors,inflated_select_recording,inflated_calibration,inflated_manual_rec,inflated_timer_rec,inflated_updateinfo;


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



    //flag for download
    public boolean flag_filetoosmall = false;

    //backup variables
    private long size_interval_backupfile=1000; //initialize at each acquisition to 1000 (1 Mb)

    private String inforecordingtext="";
    private String old_inforecordingtext="";

    //DEFINES
    private static final float THRESHOLD_BATTERY = (float) 2.2;
    private static final int THRESHOLD_WATCHDOG_TIMER = 150; //DEFAULT: 30
    private static final int SIZE_INTERVAL_BACKUPFILE = 1000; //1000, each 1 Mb

    //drawer
    private ImageButton idicon,arrowback;
    private DrawerLayout drawerLayout;
    private RelativeLayout drawer_home, drawer_support,drawer_logout,drawer_closeapp;

    private FirebaseAuth mAuth;
    private FirebaseUser user;
    private DatabaseReference reference;
    private String userID;


    public final String LOG_TAG = EnvironmentalMonitor.class.getSimpleName();


//PARAMETRI ANCORA DA SETTARE
    // GESTIONE ANT
    private static final int USER_PERIOD_SATURATION = 32768; // 3277; 10 Hz
    private static final int USER_RADIOFREQUENCY = 66; //66, so 2466 MHz;
    public static boolean serviceIsBound = false;
    private AntService mAntRadioService = null;
    public AntChannelProvider antChannelProvider;
    public AntChannel antChannelEnvironmental;      //CAMBIATO
    public ChannelType antChannelEnvironmental_type;        //CAMBIATO
    public AntMessage antMessage;
    public MessageFromAntType messagetype; //
    public boolean mIsOpen = false;
//VEDERE SE C'E' QUALCOSA DA CAMBIARE
    public ChannelId channelId_smartphone = new ChannelId(2,2,2, true); //DEFAULT: 2,2,2, true

    byte[] payLoad;

    byte[] payLoad6 = {0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06}; // payload to call Environmental Monitor unit for the first time

    //TODO-- PAYLOAD
    // TODO-- END PAYLOAD

    public String startrec_time=null;

    public int state;
    public boolean connected6 = false;


    //STATES
    private static final int INITIALIZATION = 0;
    private static final int CONNECT6 = 1;
//    private static final int SYNCHRONIZATION_RESUME = 4;
    private static final int START = 5;
    private static final int CALL6 = 6;
//    private static final int CALIBRATION = 9; //payload 8     o lo uso per impostare una calibrazione forzata? posso farlo ogni volta che lo accendo se no
    private static final int STOP = 10; //stop and resume, payload 9
    private static final int RECONNECTION = 11;
    private static final int CLOSE = 0; //close the channel


    //STATES FOR PREVENT TO QUIT WITH BACK BUTTON DURING RECORDING AND SHOW A DIALOG
    private static final int QUIT_RECORDING = 12; //quit recording

    BroadcastDataMessage broadcastDataMessage;
    public String current_default,current,day;
    //save the old message to see if there's data loss
    public String old_messageContentString_unit=null;

//PENSARE A COME GESTIRE INVIO DEI DATI E SE SERVE
    //watchdog timer to check if the sensors are receiving messages
    public int [] watchdog_timer={0};
    public int sumWt=0;
    public boolean flag_watchdog_timer_overflow = true;
    public boolean flag_reconnection = false;
    public boolean flag_sensors_disconnection = false;
    public boolean flag_sensors_disconnection_header = false;
    public String sensors_disconnection_header="You have to go back initialize the sensors because in the last recording a problem occurred with the communication.\n\nSwitch OFF the sensors and then press YES";

    private String sensorsDisconnectedText;
    private static String sensorDisconnected4="";

    private static final int UNIT6 = 0;
//FINO QUA

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.environmental_monitor);


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
        viewStub = (ViewStub) findViewById(R.id.initialization_toinclude_1);
        viewStub.setLayoutResource(R.layout.initialization_pulse_ox);
        inflated_initialization = viewStub.inflate();

//Vedere se serve anche questo
        //update info layout initialization
        viewStub = (ViewStub) findViewById(R.id.updateinforecording_toinclude);
        viewStub.setLayoutResource(R.layout.updateinfo_recording);
        inflated_updateinfo = viewStub.inflate();

        posture_buttons=(RadioGroup) inflated_updateinfo.findViewById(R.id.posture_buttons);

        layout_insert_addinforec=(TextInputLayout) inflated_updateinfo.findViewById(R.id.layout_insert_addinforec);
        insert_addinforec=(TextInputEditText) inflated_updateinfo.findViewById(R.id.insert_addinforec);

        updateinfo=(Button) inflated_updateinfo.findViewById(R.id.updateinfo);
        updateinfo.setOnClickListener(this);

        inforecording=(TextView) inflated_updateinfo.findViewById(R.id.inforecording);

        inflated_updateinfo.setVisibility(View.GONE);



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

//BISOGNA AGGIUNGERE LA SCHERMATA TIPO INITIALIZATION PULSE OX
//        initializationbutton_environmental_monitor=(Button) findViewById(R.id.initializationbutton_environmental_monitor);
//        initializationbutton_environmental_monitor.setOnClickListener(this);

//        gotoswitchonenvironmentalmonitor=(Button) findViewById(R.id.gotoswitchonenvironmentalmonitor);
//        gotoswitchonenvironmentalmonitor.setOnClickListener(this);

        progressbar_initialization=(ProgressBar) findViewById(R.id.progressbar_initialization);
        status_initialization=(TextView) findViewById(R.id.status_initialization);
        bottom_initialization=(TextView) findViewById(R.id.bottom_initialization);

        initialization_checkmark=(ImageButton) findViewById(R.id.initialization_checkmark);

    }


}
