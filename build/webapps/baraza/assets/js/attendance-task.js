
var btnrmvClass = 'btn-primary';
var btnaddClassError = 'btn-danger';
var btnaddClass = 'btn-success';
var btnaddClassWarning = 'btn-warning';
var labelrmvClass = 'label-primary';
var labeladdClass = 'label-success';
var labeladdClassError = 'label-danger';
/**
 * Clock In Button JS
 **/
$('.clock-in-btn')
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.clock-in-status-btn');
        var msg = 'Clocked In Time : 8:00am ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg);
    });

/**
 *
 * Lunch Break Button JS
 **/
$('.lunch-break-btn')
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.lunch-break-status-btn');
        var msg = 'Lunch End : 2:00pm ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg);
    });

/**
 * Evening Break Button JS
 **/
$('.break-btn')
    .click(function () {
        var btnClock = $(this);
        var btnClockStatus = $('.break-status-btn');
        var msg = 'Break End : 4:30pm ';
        btnClock.button('loading');
        postAjax(btnClock, btnClockStatus, msg);
    });

/**
 * Function for ajax and Color scheme
 * @param btnEnrtryCss
 * @param btnStatusCss
 * @param msg
 */
function postAjax(btnEnrtryCss, btnStatusCss, msg){
    var btnClock  = $(btnEnrtryCss);
    var btnClockStatus = $(btnStatusCss);
    var jsonData =                 {
        name: "Donald Duck",
        city: "Duckburg"
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
            colorChange(btnClock, btnClockStatus, btnEnrtryCss, btnrmvClass, labelrmvClass,
                btnStatusCss, btnaddClass, labeladdClass, btnMsg, msg);

        },
        error: function(xhr, resp, text) {
            var btnMsg = 'Contact System Admin';
            var labelMsg = 'An error Occured';
            colorChange(btnClock, btnClockStatus, btnEnrtryCss, btnrmvClass, labelrmvClass,
                btnStatusCss, btnaddClassError, labeladdClassError, btnMsg, labelMsg);
        }

    });
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
                     btnStatusCss, btnaddClass, labeladdClass, btnMsg, labelMsg){
//        btnClock.button('reset');
    btnClock.removeClass(btnEnrtryCss +' btn-block btn-sm '+ btnrmvClass);
    btnClock.addClass(btnEnrtryCss +' btn-block btn-sm '+ btnaddClass);
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
        var jsonData = {};
        $.each(json, function(i, field){
            jsonData [field.name] = field.value;
        });
        $.ajax({

            url: '/tasks-start', // url where to submit the request
            type : "POST", // type of action POST || GET
            dataType : 'json', // data type
            data : {"tag":"authenticate","json":JSON.stringify(jsonData)}, // post data || get data
            beforeSend: function() {//calls the loader id tag
                //                $("#loader").show();
                $(".start-task i").removeAttr('class').addClass("fa fa-refresh fa-spin fa-3x fa-fw  text-center").css({"color":"#fff",});
            },
            success : function(result) {
                var btnMsg = "<i class='fa fa-check  text-center'></i> Saved Successfully";
                colorChange(btnId, '', btnId, btnrmvClass, '',
                    '', btnaddClass, '', btnMsg, '');
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
        var jsonData = {};
        $.each(json, function(i, field){
            jsonData [field.name] = field.value;
        });

        $.ajax({

            url: '/tasks-end', // url where to submit the request
            type : "POST", // type of action POST || GET
            dataType : 'json', // data type
            data : {"tag":"authenticate","json":JSON.stringify(jsonData)}, // post data || get data
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
