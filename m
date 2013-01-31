Reply-To: kernel-hardening@lists.openwall.com
From: Anthony Liguori <aliguori@us.ibm.com>
In-Reply-To: <CAGXu5jLk6-OHdZP7wQapv1dzK39k8w6ioB_6QtJ5GvP0ZWHzcw@mail.gmail.com>
References: <510A8F11.6050908@linux.vnet.ibm.com> <CAGXu5jLk6-OHdZP7wQapv1dzK39k8w6ioB_6QtJ5GvP0ZWHzcw@mail.gmail.com>
Date: Thu, 31 Jan 2013 13:30:04 -0600
Message-ID: <874nhxb16r.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [kernel-hardening] Secure Open Source Project Guide
To: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Frank Novak <fnovak@us.ibm.com>, George Wilson <gcwilson@us.ibm.com>, Joel Schopp <jschopp@linux.vnet.ibm.com>, Kevin Wolf <kwolf@redhat.com>, Warren Grunbok II <grunbok@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Thu, Jan 31, 2013 at 7:34 AM, Corey Bryant <coreyb@linux.vnet.ibm.com> wrote:
>> In light of events like this http://lwn.net/Articles/535149/ "China, GitHub
>> and the man-in-the-middle (Greatfire)", we are thinking that a guide for
>> securing open source projects is needed.  For example, recommending pull
>> requests or commits be PGP signed are a few things we've discussed that
>> could defend against a MITM attack inserting malicious code.
>>
>> Does anyone have any thoughts as to where we could publish such a guide?
>> Perhaps the Linux Foundation?
>>
>> I believe we have the resources on this mailing list to work through the
>> details and put together a succinct guide that we could take to a wider
>> audience.
>
> Yeah, sounds good. I think we could easily use the kernel-security
> wiki to work on it initially, and if it needs a different home in the
> end, we can move it then.

If someone picks a home, I'll do a brain dump of some of my concerns and
what I think can be done about it.

Regards,

Anthony Liguori

>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security
