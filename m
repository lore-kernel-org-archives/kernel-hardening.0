Return-Path: <SRS0=pb/c=5Q=lists.openwall.com=kernel-hardening-return-18323-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5438EC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:36:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 67B2220838
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=pi3.com.pl header.i=@pi3.com.pl header.b="nTgH2VAv";
	dkim=pass (2048-bit key) header.d=pi3.com.pl header.i=@pi3.com.pl header.b="Rp3+de1H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67B2220838
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=pi3.com.pl
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18323-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30389 invoked by uid 550); 31 Mar 2020 11:36:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11549 invoked from network); 31 Mar 2020 04:30:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pi3.com.pl; s=default;
	t=1585628997; bh=S/sqsZXh4c0HiC7oiYQrHwHAsYjWmaKQdUkMuQncFzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nTgH2VAvffuUSjBDnqjOcWm2SIAHPhqpPswtjpS/nWdDBofZQfRyDM0VCEM7JnlAy
	 X8nyQIVtAbjQUmKn2eOVxdCqF2yFjGGF87UNOvsHKDaVtI0MlUHBmrhea6S+LmIUf0
	 Q7+KJCfh6DjjaJGpyVQ80LWyh5fCp6fseAlG02BOYNd6dCqbMqMyOv09LkoSuxLx9a
	 QxX7d+A3ZD9PzL5Vd6Ff+i3Muw2SaK4VmVSvz+bW9UfEwWCS+1ocY+De+iPxZJWACs
	 rlK9Ak3v2Vqjpe1gDnjmtECKKRcgDTPj/0YZa49jwwxt5wHbZCBYyB+pz0qBsNiaSC
	 avU3udQzl2iRQ==
X-Virus-Scanned: Debian amavisd-new at pi3.com.pl
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pi3.com.pl; s=default;
	t=1585628994; bh=S/sqsZXh4c0HiC7oiYQrHwHAsYjWmaKQdUkMuQncFzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rp3+de1Hs6t8uul8ccFB28NRWTmHQHtkzfTW04o2op8j6cYDC1NwIuTxPdPZDny7w
	 1V4STuCjBHQKw5wYG4f/jK2nulLt67w09hxmwrDCE4u5XiVDkoK9cgxwfA0MVBwINj
	 /8TLypBOAm3X5+pV4kWzLt65w0uffrbOLOSDyw0NCO0ksR07KRmstImwjjE9npxUqe
	 jMeTSDn1gfV+7vIkYH3mPwxXN6zsGXRyGJnrDM+njJ73p+/YMQED0bxHCQm+/YKsjB
	 nAQb7XbUY0Cvs9DxFDASN2cz3REzf9gcG3olhBXahg8Zo1KgLuq4dlT10S+LckR41U
	 bo54SIyXCUdNA==
Date: Tue, 31 Mar 2020 06:29:54 +0200
From: Adam Zabrocki <pi3@pi3.com.pl>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Bernd Edlinger <bernd.edlinger@hotmail.de>,
	Solar Designer <solar@openwall.com>
Subject: Re: Curiosity around 'exec_id' and some problems associated with it
Message-ID: <20200331042954.GA26058@pi3.com.pl>
References: <20200324215049.GA3710@pi3.com.pl>
 <202003291528.730A329@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003291528.730A329@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)

Hey,

On Sun, Mar 29, 2020 at 03:43:14PM -0700, Kees Cook wrote:
> Hi!
> 
> Sorry, I missed this originally because it got filed into my lkml
> archive and not kernel-hardening, but no one actually reads lkml
> directly, myself included -- it's mostly a thread archive. I'll update
> my filters, and I've added a handful of people to CC that might be
> interested in looking at this too. Here's the full email, I trimmed
> heavily since it's very detailed:
> https://lore.kernel.org/lkml/20200324215049.GA3710@pi3.com.pl/
> 

No worries ;-)

> On Tue, Mar 24, 2020 at 10:50:49PM +0100, Adam Zabrocki wrote:
> > Some curiosities which are interesting to point out:
> > 
> >  1) Linus Torvalds in 2012 suspected that such 'overflow' might be possible.
> >     You can read more about it here:
> > 
> >     https://www.openwall.com/lists/kernel-hardening/2012/03/11/4
> > 
> >  2) Solar Designer in 1999(!) was aware about the problem that 'exit_signal' can
> >     be abused. The kernel didn't protect it at all at that time. So he came up
> >     with the idea to introduce those two counters to deal with that problem.
> >     Originally, these counters were defined as "long long" type. However, during
> >     the revising between September 14 and September 16, 1999 he switched from
> >     "long long" to "int" and introduced integer wraparound handling. His patches
> >     were merged to the kernel 2.0.39 and 2.0.40.
> > 
> >  3) It is worth to read the Solar Designer's message during the discussion about
> >     the fix for the problem CVE-2012-0056 (I'm referencing this problem later in
> >     that write-up about "Problem II"):
> > 
> >     https://www.openwall.com/lists/kernel-hardening/2012/03/11/12
> 
> There was some effort made somewhat recently to get this area fixed:
> https://lore.kernel.org/linux-fsdevel/1474663238-22134-3-git-send-email-jann@thejh.net/
> 

These changes looks comprehensive and definitely fix current issue.

> Nothing ultimately landed, but it's worth seeing if we could revitalize
> interest. Part of Jann's series was also related to fixing issues with
> cred_guard_mutex, which is getting some traction now too:
> https://lore.kernel.org/lkml/AM6PR03MB5170938306F22C3CF61CC573E4CD0@AM6PR03MB5170.eurprd03.prod.outlook.com/
> 

Thanks for pointing to that discussion. Definately both of that changes fix 
problems which I've described (and not only that). However, what are the 
reasons behind not merging them in? Especially, the first part (exec_id) looks 
harmless and don't require any other updates.

> > In short, if you hold the file descriptor open over an execve() (e.g. share it
> > with child) the old VM is preserved (refcounted) and might be never released.
> > Essentially, mother process' VM will be still in memory (and pointer to it is
> > valid) even if the mother process passed an execve().
> > This is some kind of 'memory leak' scenario. I did a simple test where process
> > open /proc/self/maps file and calls clone() with CLONE_FILES flag. Next mother
> > 'overwrite' itself by executing SUID binary (doesn't need to be SUID), and child
> > was still able to use the original file descriptor - it's valid.
> 
> It'd be worth exploring where the resource counting is happening for
> this. I haven't looked to see how much of the VM stays in kernel memory
> in this situation. It probably wouldn't be hard to count it against an
> rlimit or something.
> 
> Thanks for the details! I hope someone will have time to look into this.
> It's a bit of a "long timeframe attack", so it's not gotta a lot of
> priority (obviously). :)
> 

Thanks :) However, I did not focus on optimizing the '*exec_id overflow' 
scenario and that's certainly possible. E.g. by creating the code as small as 
possible, don't link with external libraries (or statically compile them in), 
etc. In such case the time will be significantly smaller.

Another interesting fact (not possible for performing 'overflow' attack but 
worth to mention) is that we might increment '*exec_id' and force execve() to 
fail. Function load_elf_binary() calls setup_new_exec() (which increments the 
counter) and then continue execution of a more heavy work. In such case an 
'overflow' would be a matter of hours. However, search_binary_handler() 
function "protects" from such scenario and in case of error in 
load_elf_binary() sends SIGSEGV:

    int search_binary_handler(struct linux_binprm *bprm)
    {
    ...
        retval = fmt->load_binary(bprm);
    ...
        if (retval < 0 && !bprm->mm) {
            /* we got to flush_old_exec() and failed after it */
            read_unlock(&binfmt_lock);
            force_sigsegv(SIGSEGV, current);
            return retval;
        }
    ...
    }

flush_old_exec() is called before setup_new_exec().

Thanks,
Adam

> -Kees
> 
> -- 
> Kees Cook

-- 
pi3 (pi3ki31ny) - pi3 (at) itsec pl
http://pi3.com.pl

