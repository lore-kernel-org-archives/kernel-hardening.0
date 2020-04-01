Return-Path: <SRS0=/3/D=5R=lists.openwall.com=kernel-hardening-return-18362-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EA0C43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 23:37:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89F67206E9
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 23:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j5KKPNVG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89F67206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18362-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4051 invoked by uid 550); 1 Apr 2020 23:37:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4031 invoked from network); 1 Apr 2020 23:37:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vaEwhKzYh+esdrS+zsnAFLt/hs58JrgfVkhu1l8Vw2I=;
        b=j5KKPNVGYu2o585DNi9+bxWpfCgtnw9/ky+To5RepGt/igy9pFKVIFK7gwid+7S/4Z
         XNWvqNuC+XDfoVVC5kx18GZ/N4ge7YG3Criti6WRl/S2yfVjCIAWxiK8K9NzAE+T5QfY
         esfbUOrI7sqPMSDl1sZkOaeN1eE3GHNT8RbSqXUUDA9qgNV3nxfJg3BIF8le84hKV7+1
         nsr6rfFXN8QbwHRZyl66rSV9YafdY5w8ZaaqinYWnLmxZMv4Upb6knX0ua3uBj/Ns41s
         jHme40iA8VPDDl7u2FrE3JPBkYOvRML2CCu8dUKCcqUDcWmIuulDGzgqCbruxRtW0XsM
         26wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vaEwhKzYh+esdrS+zsnAFLt/hs58JrgfVkhu1l8Vw2I=;
        b=MSyTPWC8jomt16a8W1BQxG0Ky/4xVO/uitAYxir/1DrxOWEBoX+ORs40sAR1DhUt4Y
         AShIZx+Ejp47CKBOEjlpnhS7bCLniGhgFHoCA+8WQkYlBn3K9kk/dQblVuLHC0UZzj1B
         qtrqC3AhISrOgVV7/3BF0VRmJ4L0x4AR1LweO7fU2RGfEhE0T70fbvaBRJWbhz1hqb2i
         JEGAwKSg0P/FaHuIDcoRWPw0JN0cqSLa1ewp2DJmhgCek0P6H/nQcmbA1CeSRbJFg/zX
         IIvtXlUg75jow3ghhkqtJYSs13RrH96b/+cjiiUH57yqZRFti+NWvqXLGlN/5QuLMA28
         20FQ==
X-Gm-Message-State: AGi0PuZfrXn2DjxZccW6CEVoAIy/Hk/0A+V68H/u4Q4tXe+Zm7XfQxDp
	iTVMuccganR3rmQRLCOikYyOzPtHpGOL/l1MOicBmQ==
X-Google-Smtp-Source: APiQypJKP6HEf732WKAQ8BS0ipIdwjEib9HruAq/oVHEHyCM3/BNRHLrOL+y8npLGjaJtkYy7Y3U+LOpeZoxf3ResDk=
X-Received: by 2002:a2e:9247:: with SMTP id v7mr313238ljg.215.1585784259500;
 Wed, 01 Apr 2020 16:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook> <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 2 Apr 2020 01:37:13 +0200
Message-ID: <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Andrea Parri <parri.andrea@gmail.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, 
	Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Akira Yokosawa <akiyks@gmail.com>, 
	Daniel Lustig <dlustig@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Adam Zabrocki <pi3@pi3.com.pl>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Oleg Nesterov <oleg@redhat.com>, 
	Andy Lutomirski <luto@amacapital.net>, Bernd Edlinger <bernd.edlinger@hotmail.de>, 
	Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

+memory model folks because this seems like a pretty sharp corner

On Wed, Apr 1, 2020 at 10:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Replace the 32bit exec_id with a 64bit exec_id to make it impossible
> to wrap the exec_id counter.  With care an attacker can cause exec_id
> wrap and send arbitrary signals to a newly exec'd parent.  This
> bypasses the signal sending checks if the parent changes their
> credentials during exec.
>
> The severity of this problem can been seen that in my limited testing
> of a 32bit exec_id it can take as little as 19s to exec 65536 times.
> Which means that it can take as little as 14 days to wrap a 32bit
> exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
> days.  Even my slower timing is in the uptime of a typical server.
> Which means self_exec_id is simply a speed bump today, and if exec
> gets noticably faster self_exec_id won't even be a speed bump.
>
> Extending self_exec_id to 64bits introduces a problem on 32bit
> architectures where reading self_exec_id is no longer atomic and can
> take two read instructions.  Which means that is is possible to hit
> a window where the read value of exec_id does not match the written
> value.  So with very lucky timing after this change this still
> remains expoiltable.
>
> I have updated the update of exec_id on exec to use WRITE_ONCE
> and the read of exec_id in do_notify_parent to use READ_ONCE
> to make it clear that there is no locking between these two
> locations.
>
> Link: https://lore.kernel.org/kernel-hardening/20200324215049.GA3710@pi3.com.pl
> Fixes: 2.3.23pre2
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>
> Linus would you prefer to take this patch directly or I could put it in
> a brach and send you a pull request.
>
>  fs/exec.c             | 2 +-
>  include/linux/sched.h | 4 ++--
>  kernel/signal.c       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 0e46ec57fe0a..d55710a36056 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1413,7 +1413,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>
>         /* An exec changes our domain. We are no longer part of the thread
>            group */
> -       current->self_exec_id++;
> +       WRITE_ONCE(current->self_exec_id, current->self_exec_id + 1);

GCC will generate code for this without complaining, but I think it'll
probably generate a tearing store on 32-bit platforms:

$ cat volatile-8.c
typedef unsigned long long u64;
static volatile u64 n;
void blah(void) {
  n = n + 1;
}
$ gcc -O2 -m32 -c -o volatile-8.o volatile-8.c -Wall
$ objdump --disassemble=blah volatile-8.o
[...]
   b: 8b 81 00 00 00 00    mov    0x0(%ecx),%eax
  11: 8b 91 04 00 00 00    mov    0x4(%ecx),%edx
  17: 83 c0 01              add    $0x1,%eax
  1a: 83 d2 00              adc    $0x0,%edx
  1d: 89 81 00 00 00 00    mov    %eax,0x0(%ecx)
  23: 89 91 04 00 00 00    mov    %edx,0x4(%ecx)
[...]
$

You could maybe use atomic64_t to work around that? atomic64_read()
and atomic64_set() should be straightforward READ_ONCE() /
WRITE_ONCE() on 64-bit systems while compiling into something more
complicated on 32-bit.

>         flush_signal_handlers(current, 0);
>  }
>  EXPORT_SYMBOL(setup_new_exec);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 04278493bf15..0323e4f0982a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -939,8 +939,8 @@ struct task_struct {
>         struct seccomp                  seccomp;
>
>         /* Thread group tracking: */
> -       u32                             parent_exec_id;
> -       u32                             self_exec_id;
> +       u64                             parent_exec_id;
> +       u64                             self_exec_id;
>
>         /* Protection against (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed, mempolicy: */
>         spinlock_t                      alloc_lock;
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9ad8dea93dbb..5383b562df85 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1926,7 +1926,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>                  * This is only possible if parent == real_parent.
>                  * Check if it has changed security domain.
>                  */
> -               if (tsk->parent_exec_id != tsk->parent->self_exec_id)
> +               if (tsk->parent_exec_id != READ_ONCE(tsk->parent->self_exec_id))
>                         sig = SIGCHLD;
>         }
>
> --
> 2.20.1
>
