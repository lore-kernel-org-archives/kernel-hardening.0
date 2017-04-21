References: <20170419034526.18565-1-matt@nmatt.com>
 <20170419045813.GA17990@mail.hallyn.com>
 <a6b8f9ab-d5f8-51fb-0481-89907c43289f@nmatt.com>
 <20170419235342.GA2305@mail.hallyn.com>
 <59d67e42-3532-6001-91cb-067bff1eec64@nmatt.com>
 <20170420151928.GA14559@mail.hallyn.com>
 <0b6cec15f206329fc523983534baaf0d@nmatt.com>
 <20170420174100.GA16822@mail.hallyn.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <8e755f85-6947-cb52-003d-11f1d9a886da@nmatt.com>
Date: Fri, 21 Apr 2017 01:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <20170420174100.GA16822@mail.hallyn.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] make TIOCSTI ioctl require CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: jmorris@namei.org, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 04/20/2017 01:41 PM, Serge E. Hallyn wrote:
> Quoting matt@nmatt.com (matt@nmatt.com):
>> On 2017-04-20 11:19, Serge E. Hallyn wrote:
>>> Quoting Matt Brown (matt@nmatt.com):
>>>> On 04/19/2017 07:53 PM, Serge E. Hallyn wrote:
>>>>> Quoting Matt Brown (matt@nmatt.com):
>>>>>> On 04/19/2017 12:58 AM, Serge E. Hallyn wrote:
>>>>>>> On Tue, Apr 18, 2017 at 11:45:26PM -0400, Matt Brown wrote:
>>>>>>>> This patch reproduces GRKERNSEC_HARDEN_TTY functionality from the grsecurity
>>>>>>>> project in-kernel.
>>>>>>>>
>>>>>>>> This will create the Kconfig SECURITY_TIOCSTI_RESTRICT and the corresponding
>>>>>>>> sysctl kernel.tiocsti_restrict that, when activated, restrict all TIOCSTI
>>>>>>>> ioctl calls from non CAP_SYS_ADMIN users.
>>>>>>>>
>>>>>>>> Possible effects on userland:
>>>>>>>>
>>>>>>>> There could be a few user programs that would be effected by this
>>>>>>>> change.
>>>>>>>> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
>>>>>>>> notable programs are: agetty, csh, xemacs and tcsh
>>>>>>>>
>>>>>>>> However, I still believe that this change is worth it given that the
>>>>>>>> Kconfig defaults to n. This will be a feature that is turned on for the
>>>>>>>
>>>>>>> It's not worthless, but note that for instance before this was fixed
>>>>>>> in lxc, this patch would not have helped with escapes from privileged
>>>>>>> containers.
>>>>>>>
>>>>>>
>>>>>> I assume you are talking about this CVE:
>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1411256
>>>>>>
>>>>>> In retrospect, is there any way that an escape from a privileged
>>>>>> container with the this bug could have been prevented?
>>>>>
>>>>> I don't know, that's what I was probing for.  Detecting that the pgrp
>>>>> or session - heck, the pid namespace - has changed would seem like a
>>>>> good indicator that it shouldn't be able to push.
>>>>>
>>>>
>>>> pgrp and session won't do because in the case we are discussing
>>>> current->signal->tty is the same as tty.
>>>>
>>>> This is the current check that is already in place:
>>>> | if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
>>>> | 	return -EPERM;
>>>
>>> Yeah...
>>>
>>>> The only thing I could find to detect the tty message coming from a
>>>> container is as follows:
>>>> | task_active_pid_ns(current)->level
>>>>
>>>> This will be zero when run on the host, but 1 when run inside a
>>>> container. However this is very much a hack and could probably break
>>>> some userland stuff where there are multiple levels of namespaces.
>>>
>>> Yes.  This is also however why I don't like the current patch, because
>>> capable() will never be true in a container, so nested containers
>>> break.
>>>
>>
>> What do you mean by "capable() will never be true in a container"?
>> My understanding
>> is that if a container is given CAP_SYS_ADMIN then
>> capable(CAP_SYS_ADMIN) will return
>> true?
>
> No, capable(X) checks for X with respect to the initial user namespace.
> So for root-owned containers it will be true, but containers running in
> non-initial user namespaces cannot pass that check.
>
> To check for privilege with respect to another user namespace, you need
> to use ns_capable.  But for that you need a user_ns to target.
>

How about: ns_capable(current_user_ns(),CAP_SYS_ADMIN) ?

current_user_ns() was found in include/linux/cred.h

>>  I agree the hack I mentioned above would be a bad idea because
>> it would break
>> nested containers, but the current patch would not IMO.
>>
>> A better version of the hack could involve a config
>> CONFIG_TIOCSTI_MAX_NS_LEVEL where
>> a check would be performed to ensure that
>> task_active_pid_ns(current)->level is not
>> greater than the config value(an integer that is >= 0) .
>
> Yeah.  That would break a different set of cases than the capable
> check, I assume.  A smaller set, I think.
>
>> Again, I think we both would agree that this is not the best
>> solution. The clear
>> downside is that you could have multiple container layers where the
>> desired security
>> boundaries happened to fall at different levels. Just throwing ideas
>> around.
>
> Yup, appreciated.
>
