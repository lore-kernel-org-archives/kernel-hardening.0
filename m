MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305F429@ORSMSX103.amr.corp.intel.com>
References: <476DC76E7D1DF2438D32BFADF679FC562305B2AC@ORSMSX103.amr.corp.intel.com>
 <CAGXu5jJ4AAHP66WMGdy4A_Jm6uW_FQxMBRypv-hCy3xTEcVcVQ@mail.gmail.com> <476DC76E7D1DF2438D32BFADF679FC562305F429@ORSMSX103.amr.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 12:06:37 -0800
Message-ID: <CAGXu5jJV7qi1LeyBfZS6ppJ=ih7nTnx4Rr8tyvC-ziiJu-OszQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: %pK continuation
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 13, 2017 at 11:50 AM, Roberts, William C
<william.c.roberts@intel.com> wrote:
>> -----Original Message-----
>> From: keescook@google.com [mailto:keescook@google.com] On Behalf Of Kees
>> Cook
>> Sent: Friday, February 10, 2017 3:42 PM
>> To: Roberts, William C <william.c.roberts@intel.com>
>> Cc: kernel-hardening@lists.openwall.com
>> Subject: Re: %pK continuation
>>
>> On Fri, Feb 10, 2017 at 11:02 AM, Roberts, William C
>> <william.c.roberts@intel.com> wrote:
>> > I haven't had time to really work on the continuation of:
>> > http://www.openwall.com/lists/kernel-hardening/2016/10/07/1
>> >
>> > I think the simple approach of killing %p based on kptr_restrict
>> > remains the simplest, IMHO best way to achieve a better level of preventing
>> leaks of kernel addresses. In example of %pK going wrong can be found here:
>> >  https://googleprojectzero.blogspot.com/2017/02/lifting-hyper-visor-
>> bypassing-samsungs.html.
>>
>> There's been some experimentation in Android kernels recently based on your
>> original version, though it's not quite ready for prime-time. I'm hoping to see it
>> posted to this list soon...
>
> Oh really, do you have any links to those patches?

Not yet, but hopefully soon. I'll get them posted as soon as I have them.

-Kees

-- 
Kees Cook
Pixel Security
