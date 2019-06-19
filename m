From: Daniel Axtens <dja@axtens.net>
Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
In-Reply-To: <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
References: <20190524123816.1773-1-cmr@informatik.wtf> <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com> <1146575236.484635.1559617524880@privateemail.com> <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
Date: Wed, 19 Jun 2019 16:24:35 +1000
Message-ID: <87h88m2iu4.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
To: Andrew Donnellan <ajd@linux.ibm.com>, Christopher M Riedl <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: mjg59@google.com
List-ID: <kernel-hardening.lists.openwall.com>

Andrew Donnellan <ajd@linux.ibm.com> writes:

> On 4/6/19 1:05 pm, Christopher M Riedl wrote:>>> +	if (!xmon_is_ro) {
>>>> +		xmon_is_ro = kernel_is_locked_down("Using xmon write-access",
>>>> +						   LOCKDOWN_INTEGRITY);
>>>> +		if (xmon_is_ro) {
>>>> +			printf("xmon: Read-only due to kernel lockdown\n");
>>>> +			clear_all_bpt();
>>>
>>> Remind me again why we need to clear breakpoints in integrity mode?
>>>
>>>
>>> Andrew
>>>
>> 
>> I interpreted "integrity" mode as meaning that any changes made by xmon should
>> be reversed. This also covers the case when a user creates some breakpoint(s)
>> in xmon, exits xmon, and then elevates the lockdown state. Upon hitting the
>> first breakpoint and (re-)entering xmon, xmon will clear all breakpoints.
>> 
>> Xmon can only take action in response to dynamic lockdown level changes when
>> xmon is invoked in some manner - if there is a better way I am all ears :)
>> 
>
> Integrity mode merely means we are aiming to prevent modifications to 
> kernel memory. IMHO leaving existing breakpoints in place is fine as 
> long as when we hit the breakpoint xmon is in read-only mode.
>
> (dja/mpe might have opinions on this)

Apologies for taking so long to get back to you.

I think ajd is right. 

I think about it like this. There are 2 transitions:

 - into integrity mode

   Here, we need to go into r/o, but do not need to clear breakpoints.
   You can still insert breakpoints in readonly mode, so clearing them
   just makes things more irritating rather than safer.

 - into confidentiality mode

   Here we need to purge breakpoints and disable xmon completely.

Kind regards,
Daniel

>
> -- 
> Andrew Donnellan              OzLabs, ADL Canberra
> ajd@linux.ibm.com             IBM Australia Limited
