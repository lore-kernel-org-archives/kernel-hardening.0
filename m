Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <510BD433.2020803@linux.vnet.ibm.com>
Date: Fri, 01 Feb 2013 09:41:55 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
References: <510A8F11.6050908@linux.vnet.ibm.com> <CAGXu5jLk6-OHdZP7wQapv1dzK39k8w6ioB_6QtJ5GvP0ZWHzcw@mail.gmail.com> <510ADDAB.3010500@linux.vnet.ibm.com> <20130201141705.GA23051@openwall.com>
In-Reply-To: <20130201141705.GA23051@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Secure Open Source Project Guide
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Anthony Liguori <aliguori@us.ibm.com>, Frank Novak <fnovak@us.ibm.com>, George Wilson <gcwilson@us.ibm.com>, Joel Schopp <jschopp@linux.vnet.ibm.com>, Kevin Wolf <kwolf@redhat.com>, Warren Grunbok II <wgrunbok@vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 02/01/2013 09:17 AM, Solar Designer wrote:
> Corey, Kees, all -
>
> Why don't we bring this to the oss-security mailing list?  I think this
> topic is not in any way specific nor limited to the Linux kernel.  There
> are ~10x more people on oss-security than on kernel-hardening, and this
> topic is a better fit for oss-security than for kernel-hardening.  There
> is a wiki for the oss-security group, where such content is welcome.
> Anyone can register for an account and edit.
>
> Info on the oss-security mailing list:
>
> http://oss-security.openwall.org/wiki/mailing-lists/oss-security
>
> Subscribe here:
>
> http://oss-security.openwall.org/subscribe
>
> (Of course, Kees and many others in here are already on oss-security as
> well.  Not all, though.)
>
> On Thu, Jan 31, 2013 at 04:10:03PM -0500, Corey Bryant wrote:
>> We should probably start by gathering a list of ideas to include in the
>> guide.  Some initial ideas that come to mind are:
>>
>> * Secure programming practices (Secure "Programming for Linux
>>    and Unix HOWTO" is a good reference for Linux though probably
>>    out of date)
>
> CERT's Secure Coding resources are more current, but they're focused on
> programming languages and I think they don't cover operating system
> specific pitfalls (e.g., Linux netlink).
>
>> * Performing secure code reviews and detecting common
>>    vulnerabilities
>> * Ensuring code is reviewed by trusted parties and proper patch
>>    tagging is used
>> * Signing of releases, pull requests, patches, commits, etc by
>>    trusted parties
>> * Removing vulnerabilities with automated tooling (Static/Dynamic
>>    analysis, Fuzzing)
>
> We have some relevant links here:
>
> http://oss-security.openwall.org/wiki/
>
> and more specifically:
>
> http://oss-security.openwall.org/wiki/tools
> http://oss-security.openwall.org/wiki/links
> http://oss-security.openwall.org/wiki/code-reviews
>
> More content (and better organization of content) on the oss-security
> wiki is welcome - including on all topics you listed above.
>
> Thanks,
>
> Alexander
>
>

Thanks Alexander.  I agree, this really is targeting OSS in general so I 
think it makes sense to move to the oss-security mailing list and wiki. 
  Is anyone opposed to this or have a better idea?

And maybe we can find a good place to link to our Linux Security 
Workgroup wiki on the OSS wiki: 
http://kernsec.org/wiki/index.php/Linux_Security_Workgroup

-- 
Regards,
Corey Bryant
