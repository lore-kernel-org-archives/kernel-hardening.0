Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <510BD2E5.1020604@linux.vnet.ibm.com>
Date: Fri, 01 Feb 2013 09:36:21 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
References: <510A8F11.6050908@linux.vnet.ibm.com> <CAGXu5jLk6-OHdZP7wQapv1dzK39k8w6ioB_6QtJ5GvP0ZWHzcw@mail.gmail.com> <510ADDAB.3010500@linux.vnet.ibm.com> <201302010018.52274.PeterHuewe@gmx.de>
In-Reply-To: <201302010018.52274.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Secure Open Source Project Guide
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Anthony Liguori <aliguori@us.ibm.com>, Frank Novak <fnovak@us.ibm.com>, George Wilson <gcwilson@us.ibm.com>, Joel Schopp <jschopp@linux.vnet.ibm.com>, Kevin Wolf <kwolf@redhat.com>, Warren Grunbok II <wgrunbok@vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 01/31/2013 06:18 PM, Peter Huewe wrote:
> Hi,
>> We should probably start by gathering a list of ideas to include in the
>> guide.  Some initial ideas that come to mind are:
>>
>> * Secure programming practices (Secure "Programming for Linux
>>     and Unix HOWTO" is a good reference for Linux though probably
>>     out of date)
>> * Performing secure code reviews and detecting common
>>     vulnerabilities
>> * Ensuring code is reviewed by trusted parties and proper patch
>>     tagging is used
>> * Signing of releases, pull requests, patches, commits, etc by
>>     trusted parties
>> * Removing vulnerabilities with automated tooling (Static/Dynamic
>>     analysis, Fuzzing)
>>
>> Any thoughts?
>
> I'd definitely add
> * creating semantic patches out of the secure coding reviews / common
> vulnerabilities with coccinelle/spatch.
> (Usually the same bugs happen over and over again - see e.g. the CWE list ;)
>
> I know this goes into the direction of your last point, but is not that
> trivial to use like e.g. spatch but on the other hand provides "automatic"
> fixing.
>
> Just my two cents.
>
> PeterH
>
>

Thanks for the input.  Automated patching with Coccinelle and the like, 
and pointers to get folks started with these tools would be a great 
addition.

-- 
Regards,
Corey Bryant
