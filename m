References: <20170530132427.016053da@alans-desktop>
 <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop>
 <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop>
 <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop>
 <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk>
 <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
Date: Fri, 2 Jun 2017 12:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <20170602153647.GA2688@mail.hallyn.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/2/17 11:36 AM, Serge E. Hallyn wrote:
> Quoting Matt Brown (matt@nmatt.com):
>> On 6/1/17 5:24 PM, Alan Cox wrote:
>>>> There's a difference between "bugs" and "security bugs". Letting
>>>
>>> Not really, it's merely a matter of severity of result. A non security
>>> bug that hoses your hard disk is to anyone but security nutcases at
>>> least as bad as a security hole.
>>>
>>>> security bugs continue to get exploited because we want to flush out
>>>> bugs seems insensitive to the people getting attacked. I'd rather
>>>> protect against a class of bug than have to endless fix each bug.
>>>
>>> The others are security bugs too to varying degree
>>>
>>>>> I'm not against doing something to protect the container folks, but that
>>>>> something as with Android is a whitelist of ioctls. And if we need to do
>>>>> this with a kernel hook lets do it properly.
>>>>>
>>>>> Remember the namespace of the tty on creation
>>>>> If the magic security flag is set then
>>>>>         Apply a whitelist to *any* tty ioctl call where the ns doesn't
>>>>>                 match
>>>>>
>>>>> and we might as well just take the Android whitelist since they've kindly
>>>>> built it for us all!
>>>>>
>>>>> In the tty layer it ends up being something around 10 lines of code and
>>>>> some other file somewhere in security/ that's just a switch or similar
>>>>> with the whitelisted ioctl codes in it.
>>>>>
>>>>> That (or a similar SELinux ruleset) would actually fix the problem.
>>>>> SELinux would be better because it can also apply the rules when doing
>>>>> things like su/sudo/...  
>>>>
>>>> Just to play devil's advocate, wouldn't such a system continue to not
>>>> address your physical-console concerns? I wouldn't want to limit the
>>>
>>> It would for the cases that a whitelist and container check covers -
>>> because the whitelist wouldn't allow you to do anything but boring stuff
>>> on the tty. TIOCSTI is just one of a whole range of differently stupid
>>> and annoying opportunities. Containers do not and should not be able to
>>> set the keymap, change the video mode, use console selection, make funny
>>> beepy noises, access video I/O registers and all the other stuff like
>>> that. Nothing is going to break if we have a fairly conservative
>>> whitelist.
>>>
>>>> protection to only containers (but it's a good start), since it
>>>> wouldn't protect people not using containers that still have a
>>>> privileged TTY attached badly somewhere.
>>>
>>> How are you going to magically fix the problem. I'm not opposed to fixing
>>> the real problem but right now it appears to be a product of wishful
>>> thinking not programming. What's the piece of security code that
>>> magically discerns the fact you are running something untrusted at the
>>> other end of your tty. SELinux can do it via labelling but I don't see
>>> any generic automatic way for the kernel to magically work out when to
>>> whitelist and when not to. If there is a better magic rule than
>>> differing-namespace then provide the code.
>>>
>>> You can't just disable TIOCSTI, it has users deal with it. You can
>>> get away with disabling it for namespace crossing I think but if you do
>>> that you need to disable a pile of others.
>>>
>>> (If it breaks containers blocking TIOCSTI then we need to have a good
>>> look at algorithms for deciding when to flush the input queue on exiting
>>> a container or somesuch)
>>>
>>>> If you're talking about wholistic SELinux policy, sure, I could
>>>> imagine a wholistic fix. But for the tons of people without a
>>>> comprehensive SELinux policy, the proposed protection continues to
>>>> make sense.
>>>
>>> No it doesn't. It's completely useless unless you actually bother to
>>> address the other exploit opportunities.
>>>
>>> Right now the proposal is a hack to do 
>>>
>>> 	if (TIOCSTI && different_namespace && magic_flag)
>>>
>>
>>
>> This is not what my patch does. Mine is like:
>>
>> 	if (TIOCSTI && !ns_capable(tty->owner_user_ns, CAP_SYS_ADMIN) &&
>> 		magic_flag)
>>
>> in other words:
>> 	if (TIOCSTI && (different_owner_user_ns || !CAP_SYS_ADMIN) &&
>> 		magic_flag)
>>
>> can you specify what you mean by different_namespace? which namespace?
> 
> I think you're focusing on the wrong thing.  Your capable check (apart
> from the fact that I think I've been convinced CAP_SYS_ADMIN is wrong)
> is fine.

Can't we also have a sysctl that toggles if CAP_SYS_ADMIN is involved in
this whitelist check? Otherwise someone might leave things out of the
whitelist just because they want to use those ioctls as a privileged
process. Also restricting a privileged user from ioctls with this
whitelist approach is going to be pointless because, if the whitelist is
configurable from userspace, they will just be able to modify the
whitelist.

> 
> The key point is to not only check for TIOCSTI, but instead check for
> a whitelisted ioctl.
> 
> What would the whitelist look like?  Should configuing that be the way
> that you enable/disable, instead of the sysctl in this patchset?  So
> by default the whitelist includes all ioctls (no change), but things
> like sandboxes/sudo/container-starts can clear out the whitelist?
> 

I'm fine with moving this to an LSM that whitelists ioctls. I also want
to understand what a whitelist would like look and how you would
configure it? Does a sysctl that is a list of allowed ioctls work? I
don't want to just have a static whitelist that you can't change without
recompiling your kernel.

just running a sysctl -a on a linux box shows me one thing that looks
like a list: net.core.flow_limit_cpu_bitmap
