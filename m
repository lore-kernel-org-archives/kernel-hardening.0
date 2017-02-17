References: <alpine.LRH.2.20.1702150952360.6813@namei.org>
 <201702152342.GBH04183.FOFJFHQOLMOtVS@I-love.SAKURA.ne.jp>
 <a5022e72-287b-e0d1-aa54-888eb569ac1f@schaufler-ca.com>
 <201702162000.EAC43726.FOSVQtJFHMFOLO@I-love.SAKURA.ne.jp>
 <63b8eab1-4384-688a-33cd-b648c99497a8@schaufler-ca.com>
 <201702180005.JAG65118.OMFtFFLHOJVOSQ@I-love.SAKURA.ne.jp>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <745112f3-451f-8078-43c6-0a91f630ffe9@schaufler-ca.com>
Date: Fri, 17 Feb 2017 09:29:00 -0800
MIME-Version: 1.0
In-Reply-To: <201702180005.JAG65118.OMFtFFLHOJVOSQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC v2 PATCH 1/2] security: introduce
 CONFIG_SECURITY_WRITABLE_HOOKS
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2/17/2017 7:05 AM, Tetsuo Handa wrote:
> Casey Schaufler wrote:
>> On 2/16/2017 3:00 AM, Tetsuo Handa wrote:
>>> Casey Schaufler wrote:
>>>> I can't say that I'm buying the value of the additional
>>>> complexity here. Sure, you're protecting part of the data
>>>> all the time, but you're exposing part all the time, too.
>>> Will you explain it in detail? As far as I know, __ro_after_init
>>> annotation makes the kernel to call set_memory_ro() after __init
>>> functions are completed, by gathering such variables into a section
>>> so that set_memory_ro() can change page flags for a memory region
>>> where it is PAGE_ALIGNED and the size is multiple of PAGE_SIZE bytes.
>>>
>>> This "struct lsm_entry" is for gathering only LSM related variables which
>>> would have been marked as __ro_after_init if CONFIG_SECURITY_WRITABLE_HOOKS=n
>>> into a list of memory regions where they are PAGE_ALIGNED and the size is
>>> multiple of PAGE_SIZE bytes, so that the kernel can call set_memory_ro() on
>>> these memory regions even if CONFIG_SECURITY_SELINUX_DISABLE=y or allowing
>>> LKM based LSMs.
>> All I'm saying is that it's simpler to mark the entire
>> structure than it is to mark parts.
> I'm still unable to understand.
> "struct lsm_entry" != "the entire structure" ?
>
>>>> For now I think that the solution James proposes makes the
>>>> most sense. In the hypothetical loadable modules case I
>>>> don't see real value in hardening bits of the data while
>>>> explicitly making the most important parts dynamic.
>>> Best solution for environments where it is known to enforce only one specific
>>> LSM module and no user choices and no LKM based LSMs (including antivirus or
>>> alike) is to directly embed that LSM module into security/security.c .
>> There are too few beers on the table in front of me
>> to start that discussion. :)
>>
>>> CONFIG_SECURITY_WRITABLE_HOOKS=n depends on CONFIG_SECURITY_SELINUX_DISABLE=n
>>> but many of distributor's kernels enable multiple LSM modules including
>>> CONFIG_SECURITY_SELINUX_DISABLE=y. Also, people are using antivirus software
>>> on distributor's kernels.
>> I have to limit my comment on that to pointing out
>> that we can't make decisions based on code that has
>> never been proposed for the mainline.
> If I recall correctly, LSM framework was considered as "should be used by only
> rule based access restriction mechanisms (so-called MAC)". Hooks for e.g.
> antivirus modules should use different interfaces (e.g. fsnotify_open())
> which do not offer ability to reject access requests synchronously.
> I think that this technical barrier was removed by commit b1d9e6b0646d0e5e "LSM:
> Switch to lists of hooks". But there still remains non-technical barrier.

The LSM infrastructure is 20 years old (or close too) and
as anyone who's raised a child can attest, what you expected
in the beginning is rarely what you end up with. We have some
really good implementations of MAC, but they have never been
the glint in the community's eye.


> We think that we should not merge similar modules which provide same functionality.
> What about antivirus modules? They offer same functionality (intercept and judge
> access requests) but interface details vary depending on userspace daemon which
> performs actual scan. They cannot be unified, but we won't agree with merging
> all product's all implementations. Do we change our mind and encourage antivirus
> modules developers to try proposing for the mainline?

Security means so many things to so many people
(There are people who think queuing up for an hour
to get a body scan is an element of security.)
that restricting the LSM infrastructure to MAC seems
a bit arrogant. I am *not* saying that I support
allowing security modules that are nothing more than
interfaces for proprietary, out of tree mechanisms.
Those are evil. I would encourage an antivirus (or
time based access control, or content based denial)
to use the LSM infrastructure if it is all going upstream,
where it belongs.

>>>  At least one antivirus software (which allows
>>> anonymous download of LKM source code) is using LSM hooks since Linux 2.6.32
>>> instead of rewriting syscall tables. We are already allowing multiple concurrent
>>> LSM modules (up to one fully armored module which uses "struct cred"->security
>>> field or exclusive hooks like security_xfrm_state_pol_flow_match(), plus
>>> unlimited number of lightweight modules which do not use "struct cred"->security
>>> nor exclusive hooks) as long as they are built into the kernel. There is no
>>> reason to keep LKM based LSM modules from antivirus software or alike away.
>> We're not to the point where in-kernel modules are stacking fully.
>> Not everyone is on board for that, but hope springs eternal. Part
>> of the design criteria I'm working under is that it shouldn't
>> preclude loadable modules, and I still think that's doable. The
>> patch James proposed is completely compatible with this philosophy.
>> You can argue that it requires a loadable module configuration be
>> less "hardened", but the opponents of loadable modules say that is
>> inherent to loadable modules.
> The patch James proposed looks like a placebo for me, for many of distributor
> kernels will have to choose CONFIG_SECURITY_WRITABLE_HOOKS=y. If we offer a way to
> call set_memory_ro()/set_memory_rw(), such distributor kernels will be able to
> behave like CONFIG_SECURITY_WRITABLE_HOOKS=n.
>
>>> For such kernels, this "struct lsm_entry" allows calling set_memory_ro() on LSM
>>> related variables which would have been marked as __ro_after_init if
>>> CONFIG_SECURITY_WRITABLE_HOOKS=n.
>>>
>>> If you are not happy with using kmalloc() for copying "struct security_hook_list"
>>> in each LSM module, can we agree with padding "struct security_hook_list" in each
>>> LSM module PAGE_ALIGNED and the size being multiple of PAGE_SIZE bytes?
>> I don't understand what that would help without
>> the rest of your changes.
> Of course I mean with the rest of my changes in order to track list of LSMs.
> pax_open_kernel() might be an interesting approach which will eliminate the need
> of tracking list of LSMs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
