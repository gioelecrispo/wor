function [] = sendReportMail(config, wrongSignatures)
% Note: Only works with gmail senders

%%% Getting username 
userIndex = strfind(config.reportOptions.sender, '@');
username = config.reportOptions.sender(1:userIndex-1);

%%% Setting preferences and properties
setpref('Internet','SMTP_Server', 'smtp.gmail.com');
setpref('Internet','E_mail', config.reportOptions.sender);
setpref('Internet','SMTP_Username', username);
setpref('Internet','SMTP_Password', config.reportOptions.password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth', 'true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port', '465');

%%% Defining subject and text
subject = [config.databaseName ' has finished'];
wrongSignaturesStr = [];
if ~isempty(wrongSignatures(1).signature)
    wrongSignaturesStr = [num2str(wrongSignatures(1).signature) ' for cause: ' wrongSignatures(1).cause.message ';' newline];
    for i = 2 : length(wrongSignatures)
        wrongSignaturesStr = [wrongSignaturesStr num2str(wrongSignatures(i).signature) ' for cause: ' wrongSignatures(i).cause.message ';' newline];
    end
end
text = ['The algorithm has just finished to compute the ' config.databaseName ' database. ' newline ...
        'The wrong signatures are:' newline wrongSignaturesStr '.'];
    
%%% Sending mail
sendmail(config.reportOptions.receiver, subject, text);

end