
var btnrmvClass = 'btn-primary';
var btnaddClassError = 'btn-danger';
var btnaddClass = 'btn-success';
var btnaddClassWarning = 'btn-warning';
var labelrmvClass = 'label-primary';
var labeladdClass = 'label-success';
var labeladdClassError = 'label-danger';
var btnLunch = $(".lunch-break-btn");
var btnBreak = $(".break-btn");
var btnClockIn = $(".clock-in-btn");
var btnClockOut = $(".clock-out-btn");

/**
 * Clock In Button JS
 **/
btnClockIn
    .click(function () {
        var btnClock = $(this);
        var unHideBtnClock = $('.clock-out-btn');
        var btnClockStatus = $('.clock-in-status-btn');
        var msg = 'Clocked In Time : 8:00am ';
        btnClock.button('loading');
        postAjax(btnClock, unHideBtnClock, btnClockStatus, msg, '1', 'IN');
    });

/**
 * Clock Out Button JS
 **/
btnClockOut
    .click(function () {
        var btnClock = $(this);
        var unHideBtnClock = $('.clock-out-btn');
        var btnClockStatus = $('.clock-in-status-btn');
        var msg = 'Clocked In Time : 8:00am ';
        btnClock.button('loading');
        postAjax(btnClock, unHideBtnClock, btnClockStatus, msg, '1', 'OUT');
    });


/**
 *
 * Lunch Break Button JS
 **/
btnLunch
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.lunch-break-status-btn');
        var msg = 'Lunch End : 2:00pm ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg, '4', 'LUNCHOUT');
    });

/**
 *
 * Lunch Out Button JS
 **/
$('.lunch-break-out-btn')
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.lunch-break-status-btn');
        var msg = 'Lunch End : 2:00pm ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg, '4', 'LUNCHIN');
    });

/**
 * Evening Break Button JS
 **/
btnBreak
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.break-status-btn');
        var msg = 'Break End : 4:30pm ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg, '7', 'BREAKOUT');
    });

/**
 * Evening Break Out Button JS
 **/
$('.break-out-btn')
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.break-status-btn');
        var msg = 'Break End : 4:30pm ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg, '7', 'BREAKIN');
    });

/**
 * Function for ajax and Color scheme
 * @param btnEnrtryCss
 * @param btnStatusCss
 * @param msg
 */
function postAjax(btnEnrtryCss, unHideBtn, btnStatusCss, msg, logType, logInOut){
    var btnClock  = $(btnEnrtryCss);
    var btnClockStatus = $(btnStatusCss);
    var oldBtnClass = '';
    var outBtnNewClassName = '';
    var jsonData =                 {
        log_type: logType,
        log_in_out: logInOut
    };

    $.ajax({
        url: 'ajax', // url where to submit the request
        type : "POST", // type of action POST || GET
        dataType : 'json', // data type
        data : {"fnct":"attendance","json":JSON.stringify(jsonData)}, // post data || get data
        beforeSend: function() {//calls the loader id tag
            $(".submit i").removeAttr('class').addClass("fa fa-refresh fa-spin fa-3x fa-fw  text-center").css({"color":"#fff",});
        },
        success : function(result) {
            var btnMsg = 'Check Out';
            for(var data in result){
                var log_type = result[data].log_type;
                 msg = '';
                if(log_type == 1){
                    //btnMsg = "CLOCK OUT";
                    //outBtnNewClassName = 'clock-out-btn' ;
                    //oldBtnClass  = 'clock-in-btn';
                    //msg = 'Clocked In Time :'+result[data].log_time;
                    if(logInOut == 'IN'){
                        btnMsg = "CLOCK OUT";
                        msg = 'Clocked In Time :'+result[data].log_time;
                        outBtnNewClassName = 'clock-out-btn' ;
                        oldBtnClass  = 'clock-in-btn';

                        btnLunch.attr('disabled','disabled');//if clocked in activate lunch button
                        btnBreak.attr('disabled','disabled');//if clocked in activate break button
                        btnClockIn.show();//hide clocin in button
                        btnClockOut.hide();//show clock out button
                    }
                    if(logInOut == 'OUT'){
                        btnMsg = "CLOCKING DONE";
                        msg = 'Clocked Out Time : 5:00pm';
                        outBtnNewClassName = 'clock-out-btn' ;
                        oldBtnClass  = 'clock-in-btn';
                    }
                }
                if(log_type == 4){
                    btnMsg = "LUNCH OUT";
                    msg = 'Lunch End :'+result[data].log_time;
                    outBtnNewClassName = 'lunch-break-out-btn';
                    oldBtnClass  = 'lunch-break-btn';
                }
                if(log_type == 7){
                    btnMsg = "BREAK OUT";
                    outBtnNewClassName = 'break-out-btn';
                    oldBtnClass  = 'break-btn';
                    msg = 'Break End :'+result[data].log_time;
                }

            }
            buttonVisible(btnClock,unHideBtn,  btnClockStatus, labelrmvClass, btnStatusCss, labeladdClass, msg);
            changeBtnMsg(btnClock, btnMsg);

            //colorChange(btnClock, btnClockStatus, oldBtnClass, btnrmvClass, labelrmvClass,
            //    btnStatusCss, btnaddClass, labeladdClass, btnMsg, msg, outBtnNewClassName);

        },
        error: function(xhr, resp, text) {
            var btnMsg = 'Contact System Admin';
            var labelMsg = 'An error Occured';
            colorChange(btnClock, btnClockStatus, oldBtnClass, btnrmvClass, labelrmvClass,
                btnStatusCss, btnaddClassError, labeladdClassError, btnMsg, labelMsg, '');
        }

    });
}
/**
 *
 * @param hidebtnClock
 * @param unhidebtnClock
 * @param btnClockStatus
 * @param labelrmvClass
 * @param btnStatusCss
 * @param labeladdClass
 * @param labelMsg
 */
function buttonVisible(hidebtnClock, unhidebtnClock, btnClockStatus, labelrmvClass, btnStatusCss,
                       labeladdClass, labelMsg){
    hidebtnClock.hide();
    unhidebtnClock.show();

    btnClockStatus.removeClass('label '+ labelrmvClass +' '+ btnStatusCss);
    btnClockStatus.addClass('label '+ labeladdClass +' '+ btnStatusCss);
    btnClockStatus.html(labelMsg);
}
/**
 *
 * @param btnClass
 * @param btnMsg
 */
function changeBtnMsg(btnClass, btnMsg){
    btnClass.html(btnMsg);
    btnClass.attr('disabled','disabled');
}
/**
 * Javascript handle Color Transformations
 * @param btnClock
 * @param btnClockStatus
 * @param btnEnrtryCss
 * @param btnrmvClass
 * @param labelrmvClass
 * @param btnStatusCss
 * @param btnaddClass
 * @param labeladdClass
 */
function colorChange(btnClock , btnClockStatus, btnEnrtryCss, btnrmvClass, labelrmvClass,
                     btnStatusCss, btnaddClass, labeladdClass, btnMsg, labelMsg, outBtnoldBtnClassName){
//        btnClock.button('reset');
    btnClock.removeClass(btnEnrtryCss +' btn-block btn-sm '+ btnrmvClass);
    btnClock.addClass(outBtnoldBtnClassName +' btn-block btn-sm '+ btnaddClass);
    btnClock.html(btnMsg);

    btnClockStatus.removeClass('label '+ labelrmvClass +' '+ btnStatusCss);
    btnClockStatus.addClass('label '+ labeladdClass +' '+ btnStatusCss);
    btnClockStatus.html(labelMsg);
}

$('.tasks-manage').select2({
    placeholder: "Select",
    allowClear: true
});

$('#start-task')
    .click(function () {
        var btnId = $('.start-task');
        var btnRId = $('#start-task');
        var json = $('#task-manage').serializeArray();
        console.log(" select " + json);
        var jsonData = {start:"true"};
        $.each(json, function(i, field){
            jsonData [field.name] = field.value;
        });
        $.ajax({

            url: 'ajax', // url where to submit the request
            type : "POST", // type of action POST || GET
            dataType : 'json', // data type
            data : {"fnct":"task","json":JSON.stringify(jsonData)}, // post data || get data
            beforeSend: function() {//calls the loader id tag
                //                $("#loader").show();
                $(".start-task i").removeAttr('class').addClass("fa fa-refresh fa-spin fa-3x fa-fw  text-center").css({"color":"#fff",});
            },
            success : function(result) {
                    //If successfull hide the form display the display
                $('.task-manage-form').hide();
                $('#display-task').show();
            },
            error: function(xhr, resp, text) {
                var btnMsg = "<i class='fa fa-warning text-center'></i> Save Failed";
                btnaddClass = 'btn-danger';
                $('#end-task').show();
                colorChange(btnId, null, btnId, btnrmvClass, '',
                    '', btnaddClass, '', btnMsg, '');

            }

        });

    });

$('#end-task')
    .click(function () {
        btnrmvClass = 'btn-warning';
        var btnId = $('.end-task');
        var json = $('#task-manage').serializeArray();
        console.log(" select " + json);
        var jsonData = {start:"false"};
        $.each(json, function(i, field){
            jsonData [field.name] = field.value;
        });

        $.ajax({
            url: 'ajax', // url where to submit the request
            type : "POST", // type of action POST || GET
            dataType : 'json', // data type
            data : {"fnct":"task","json":JSON.stringify(jsonData)}, // post data || get data
            beforeSend: function() {//calls the loader id tag
                $('#start-task').hide();
                $(".end-task i").removeAttr('class').addClass("fa fa-refresh fa-spin fa-3x fa-fw  text-center").css({"color":"#fff",});
            },
            success : function(result) {
                var btnMsg = "<i class='fa fa-check  text-center'></i> Saved Successfully";
                colorChange(btnId, '', btnId, btnrmvClass, '',
                    '', btnaddClass, '', btnMsg, '');
            },
            error: function(xhr, resp, text) {
                var btnMsg = "<i class='fa fa-warning  text-center'></i> Save Failed";
                btnaddClass = 'btn-danger';
                colorChange(btnId, '', btnId, btnrmvClass, '',
                    '', btnaddClass, '', btnMsg, '');
            }

        });

    });
