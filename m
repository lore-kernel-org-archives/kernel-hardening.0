Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
References: <20190524123816.1773-1-cmr@informatik.wtf>
 <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com>
 <1146575236.484635.1559617524880@privateemail.com>
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Tue, 4 Jun 2019 13:28:13 +1000
MIME-Version: 1.0
In-Reply-To: <1146575236.484635.1559617524880@privateemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
To: Christopher M Riedl <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
Cc: mjg59@google.com, dja@axtens.net
List-ID: <kernel-hardening.lists.openwall.com>

On 4/6/19 1:05 pm, Christopher M Riedl wrote:>>> +	if (!xmon_is_ro) {
>>> +		xmon_is_ro = kernel_is_locked_down("Using xmon write-access",
>>> +						   LOCKDOWN_INTEGRITY);
>>> +		if (xmon_is_ro) {
>>> +			printf("xmon: Read-only due to kernel lockdown\n");
>>> +			clear_all_bpt();
>>
>> Remind me again why we need to clear breakpoints in integrity mode?
>>
>>
>> Andrew
>>
> 
> I interpreted "integrity" mode as meaning that any changes made by xmon should
> be reversed. This also covers the case when a user creates some breakpoint(s)
> in xmon, exits xmon, and then elevates the lockdown state. Upon hitting the
> first breakpoint and (re-)entering xmon, xmon will clear all breakpoints.
> 
> Xmon can only take action in response to dynamic lockdown level changes when
> xmon is invoked in some manner - if there is a better way I am all ears :)
> 

Integrity mode merely means we are aiming to prevent modifications to 
kernel memory. IMHO leaving existing breakpoints in place is fine as 
long as when we hit the breakpoint xmon is in read-only mode.

(dja/mpe might have opinions on this)

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited
