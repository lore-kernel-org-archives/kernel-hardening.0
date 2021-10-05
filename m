Return-Path: <SRS0=UOBK=OZ=lists.openwall.com=kernel-hardening-return-21414-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2356DC433EF
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Oct 2021 19:49:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2ACFF6124C
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Oct 2021 19:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2ACFF6124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 30683 invoked by uid 550); 5 Oct 2021 19:49:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30646 invoked from network); 5 Oct 2021 19:49:44 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexander Popov <alex.popov@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,  Petr Mladek
 <pmladek@suse.com>,  "Paul E. McKenney" <paulmck@kernel.org>,  Jonathan
 Corbet <corbet@lwn.net>,  Andrew Morton <akpm@linux-foundation.org>,
  Thomas Gleixner <tglx@linutronix.de>,  Peter Zijlstra
 <peterz@infradead.org>,  Joerg Roedel <jroedel@suse.de>,  Maciej Rozycki
 <macro@orcam.me.uk>,  Muchun Song <songmuchun@bytedance.com>,  Viresh
 Kumar <viresh.kumar@linaro.org>,  Robin Murphy <robin.murphy@arm.com>,
  Randy Dunlap <rdunlap@infradead.org>,  Lu Baolu
 <baolu.lu@linux.intel.com>,  Kees Cook <keescook@chromium.org>,  Luis
 Chamberlain <mcgrof@kernel.org>,  Wei Liu <wl@xen.org>,  John Ogness
 <john.ogness@linutronix.de>,  Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>,  Alexey Kardashevskiy
 <aik@ozlabs.ru>,  Christophe Leroy <christophe.leroy@csgroup.eu>,  Jann
 Horn <jannh@google.com>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  Mark Rutland <mark.rutland@arm.com>,  Andy Lutomirski <luto@kernel.org>,
  Dave Hansen <dave.hansen@linux.intel.com>,  Steven Rostedt
 <rostedt@goodmis.org>,  Will Deacon <will.deacon@arm.com>,  David S Miller
 <davem@davemloft.net>,  Borislav Petkov <bp@alien8.de>,  Kernel Hardening
 <kernel-hardening@lists.openwall.com>,  linux-hardening@vger.kernel.org,
  "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,  Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>,  notify@kernel.org
References: <20210929185823.499268-1-alex.popov@linux.com>
	<d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
	<20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1>
	<YVWAPXSzFNbHz6+U@alley>
	<CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
	<ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
	<CAHk-=whrLuVEC0x+XzYUNV2de5kM-k39GkJWwviQNuCdZ0nfKg@mail.gmail.com>
	<0e847d7f-7bf0-cdd4-ba6e-a742ce877a38@linux.com>
Date: Tue, 05 Oct 2021 14:48:47 -0500
In-Reply-To: <0e847d7f-7bf0-cdd4-ba6e-a742ce877a38@linux.com> (Alexander
	Popov's message of "Sun, 3 Oct 2021 00:05:56 +0300")
Message-ID: <87zgrnqmlc.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mXqRH-008ayT-2v;;;mid=<87zgrnqmlc.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19LbUxC2F3Wifzbmkmxv5sYTECcq8ioZjc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexander Popov <alex.popov@linux.com> writes:

> On 02.10.2021 19:52, Linus Torvalds wrote:
>> On Sat, Oct 2, 2021 at 4:41 AM Alexander Popov <alex.popov@linux.com> wrote:
>>>
>>> And what do you think about the proposed pkill_on_warn?
>> 
>> Honestly, I don't see the point.
>> 
>> If you can reliably trigger the WARN_ON some way, you can probably
>> cause more problems by fooling some other process to trigger it.
>> 
>> And if it's unintentional, then what does the signal help?
>> 
>> So rather than a "rationale" that makes little sense, I'd like to hear
>> of an actual _use_ case. That's different. That's somebody actually
>> _using_ that pkill to good effect for some particular load.
>
> I was thinking about a use case for you and got an insight.
>
> Bugs usually don't come alone. Killing the process that got WARN_ON() prevents
> possible bad effects **after** the warning. For example, in my exploit for
> CVE-2019-18683, the kernel warning happens **before** the memory corruption
> (use-after-free in the V4L2 subsystem).
> https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
>
> So pkill_on_warn allows the kernel to stop the process when the first signs of
> wrong behavior are detected. In other words, proceeding with the code execution
> from the wrong state can bring more disasters later.
>
>> That said, I don't much care in the end. But it sounds like a
>> pointless option to just introduce yet another behavior to something
>> that should never happen anyway, and where the actual
>> honest-to-goodness reason for WARN_ON() existing is already being
>> fulfilled (ie syzbot has been very effective at flushing things like
>> that out).
>
> Yes, we slowly get rid of kernel warnings.
> However, the syzbot dashboard still shows a lot of them.
> Even my small syzkaller setup finds plenty of new warnings.
> I believe fixing all of them will take some time.
> And during that time, pkill_on_warn may be a better reaction to WARN_ON() than
> ignoring and proceeding with the execution.
>
> Is that reasonable?

I won't comment on the sanity of the feature but I will say that calling
it oops_on_warn (rather than pkill_on_warn), and using the usual oops
facilities rather than rolling oops by hand sounds like a better
implementation.

Especially as calling do_group_exit(SIGKILL) from a random location is
not a clean way to kill a process.  Strictly speaking it is not even
killing the process.

Partly this is just me seeing the introduction of a
do_group_exit(SIGKILL) call and not likely the maintenance that will be
needed.  I am still sorting out the problems with other randomly placed
calls to do_group_exit(SIGKILL) and interactions with ptrace and
PTRACE_EVENT_EXIT in particular.

Which is a long winded way of saying if I can predictably trigger a
warning that calls do_group_exit(SIGKILL), on some architectures I can
use ptrace and  can convert that warning into a way to manipulate the
kernel stack to have the contents of my choice.

If anyone goes forward with this please use the existing oops
infrastructure so the ptrace interactions and anything else that comes
up only needs to be fixed once.

Eric
