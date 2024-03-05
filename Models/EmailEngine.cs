using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;

namespace SCDTM.Models
{
    public class EmailEngine
    {
        /// <summary>
        /// Send email with one attachment
        /// </summary>
        /// <param name="to"></param>
        /// <param name="cc"></param>
        /// <param name="bcc"></param>
        /// <param name="from"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        public void SendEmail(string to, string cc, string bcc, string from, string subject, string body)
        {
            try
            {
                if (string.IsNullOrEmpty(to))
                {
                    throw new ArgumentException("Must contain at least one 'TO' email, CSV enabled.", "to");
                }

                if (string.IsNullOrEmpty(subject))
                {
                    throw new ArgumentException("Must contain a subject.", "subject");
                }

                var msg = new MailMessage
                {
                    Subject = subject,
                    BodyEncoding = Encoding.UTF8,
                    IsBodyHtml = true,
                    Body = body,
                };

                if (from != null)
                {
                    msg.From = new MailAddress(from);
                }
                else
                {
                    msg.From = new MailAddress("developers@digitaltargetmarketing.com");
                }

                foreach (var email in to.Split(';'))
                {
                    if (!string.IsNullOrWhiteSpace(email))
                        msg.To.Add(email);
                }

                if (!string.IsNullOrEmpty(cc))
                {
                    foreach (var email in cc.Split(';'))
                    {
                        if (!string.IsNullOrWhiteSpace(email))
                            msg.CC.Add(email);
                    }
                }

                if (!string.IsNullOrEmpty(bcc))
                {
                    foreach (var email in bcc.Split(';'))
                    {
                        if (!string.IsNullOrWhiteSpace(email))
                            msg.Bcc.Add(email);
                    }
                }

                using (var client = new SmtpClient("Vigilant"))
                {
                    client.Send(msg);
                }
            }
            catch (Exception ex)
            {
                try
                {
                    const string source = "Dtm API";
                    if (!EventLog.SourceExists(source))
                        EventLog.CreateEventSource(source, source);

                    EventLog.WriteEntry(source, string.Format("Body: {0}\n\n\n Stacktrace: {1}", body, ex.InnerException), EventLogEntryType.Error);
                }
                catch
                {
                    Trace.TraceError("{0}\n\n{1}", ex, "Cannot write to eventlog");
                }
            }
        }
    }
}
