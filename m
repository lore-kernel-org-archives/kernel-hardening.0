Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <510ADDAB.3010500@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 16:10:03 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
References: <510A8F11.6050908@linux.vnet.ibm.com> <CAGXu5jLk6-OHdZP7wQapv1dzK39k8w6ioB_6QtJ5GvP0ZWHzcw@mail.gmail.com>
In-Reply-To: <CAGXu5jLk6-OHdZP7wQapv1dzK39k8w6ioB_6QtJ5GvP0ZWHzcw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Secure Open Source Project Guide
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Anthony Liguori <aliguori@us.ibm.com>, Frank Novak <fnovak@us.ibm.com>, George Wilson <gcwilson@us.ibm.com>, Joel Schopp <jschopp@linux.vnet.ibm.com>, Kevin Wolf <kwolf@redhat.com>, Warren Grunbok II <wgrunbok@vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 01/31/2013 01:37 PM, Kees Cook wrote:
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
>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security
>
>
>

Does it make sense to get everyone edit access to the wiki?  If not I 
can set up a page for it and get input from folks here on the mailing 
list as it progresses and update the wiki myself.

We should probably start by gathering a list of ideas to include in the 
guide.  Some initial ideas that come to mind are:

* Secure programming practices (Secure "Programming for Linux
   and Unix HOWTO" is a good reference for Linux though probably
   out of date)
* Performing secure code reviews and detecting common
   vulnerabilities
* Ensuring code is reviewed by trusted parties and proper patch
   tagging is used
* Signing of releases, pull requests, patches, commits, etc by
   trusted parties
* Removing vulnerabilities with automated tooling (Static/Dynamic
   analysis, Fuzzing)

Any thoughts?

-- 
Regards,
Corey Bryant
