Return-Path: <SRS0=0rDu=VE=lists.openwall.com=kernel-hardening-return-16380-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DDFC48BDE
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Jul 2019 16:15:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6A0020838
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Jul 2019 16:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWOzKVht"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6A0020838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16380-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1095 invoked by uid 550); 7 Jul 2019 16:15:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1060 invoked from network); 7 Jul 2019 16:15:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HPjV5oIkkTKWgs8bzuMudxn+m/34k9ESgX/d9EjKBY4=;
        b=TWOzKVhtLNsWGzSmCaNZ6b/RZ3+Q0QunAQWRvFiNWs1RisWJjT0tbEfSaH4szCiWfq
         82uSZ4Xvjt6zWF5p026f32NIV/sy/6hd5AsJxTSsxrgwzMPdbEP44HkqaP+B9Q8QLvGY
         ECPuLqNdhl4Y6DYcbNZMIdDn10XiRwz+pYUe3zKKKxaTqkouVwh3CpK/NeQ4lfy4Qzci
         /LwMAd/E0YTYFdoEsh6AH3BYOxqZKfKOUnfH6U1WpPC+HbFE6z/yYoBAGaPxrM2iA4PE
         RA7UnwRtCLj3ZAlGqYs/vpvDG83e6mXKuSofbiuIMkue5dKOkbDzFhtM4/9W0v3YYfRI
         BqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPjV5oIkkTKWgs8bzuMudxn+m/34k9ESgX/d9EjKBY4=;
        b=V0UrPrsZR7+UhHaKzUaVUSEU2BYvjPA+fHySymNvfd8Q/LeVbmCO9dOoylltsL/iAi
         U8r8brr5my2DNnpF6297pfMJyuyh0lQbQNxpunDspKHeBy9JIkx+xUUKXxyu4bQoHvfW
         /UfHPvvs6++5oJpkxvIlY8F4F3AokuuOcGkKmYfknNN+2JlOdikuB3G5YFM0emOtUOBC
         D+9HorMggqwHgdaT6IC4pJiw19Yg2g5wZoHwuNLgEjB/ptcPYnACiesifgWTDPUeWU6Q
         g+2DNrgy1SRS972msMlLDfM7xdDelfUWhCaMzW/6/RtRGkhY74vK0TSappkO9rm1bX+K
         x9Bw==
X-Gm-Message-State: APjAAAWA5++z5nEL6n5OBR2qmpuMJyy4VmbXfhPtCEedlvzUj/Jbxbog
	c7Ko16PR4OIlLYDpsxrmLpfkC5iEwAEkepVvLHQ=
X-Google-Smtp-Source: APXvYqyUye9cz+0n15zQ4gOArOoK5kXFrcrLZZSEtAMpudDveLjSJuBRU+UsJPJBC8N4qob10YrUs4SNp8kqivMgQUg=
X-Received: by 2002:a6b:e20a:: with SMTP id z10mr7315185ioc.76.1562516120337;
 Sun, 07 Jul 2019 09:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-12-git-send-email-s.mesoraca16@gmail.com> <CAG48ez0uFX4AniOk1W0Vs6j=7Q5QfSFQTrBBzC2qL2bpWn_yCg@mail.gmail.com>
In-Reply-To: <CAG48ez0uFX4AniOk1W0Vs6j=7Q5QfSFQTrBBzC2qL2bpWn_yCg@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 7 Jul 2019 18:15:09 +0200
Message-ID: <CAJHCu1K-x1tCehO1CxTf9ZzVKLh44dE9hwWWSCxnW1A4SHX=kQ@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] S.A.R.A.: /proc/*/mem write limitation
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Brad Spengler <spender@grsecurity.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, 
	Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset="UTF-8"

Jann Horn <jannh@google.com> wrote:
>
> On Sat, Jul 6, 2019 at 12:55 PM Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
> > Prevent a task from opening, in "write" mode, any /proc/*/mem
> > file that operates on the task's mm.
> > A process could use it to overwrite read-only memory, bypassing
> > S.A.R.A. restrictions.
> [...]
> > +static void sara_task_to_inode(struct task_struct *t, struct inode *i)
> > +{
> > +       get_sara_inode_task(i) = t;
>
> This looks bogus. Nothing is actually holding a reference to `t` here, right?

I think you are right, I should probably store the PID here.

> > +}
> > +
> >  static struct security_hook_list data_hooks[] __lsm_ro_after_init = {
> >         LSM_HOOK_INIT(cred_prepare, sara_cred_prepare),
> >         LSM_HOOK_INIT(cred_transfer, sara_cred_transfer),
> >         LSM_HOOK_INIT(shm_alloc_security, sara_shm_alloc_security),
> > +       LSM_HOOK_INIT(task_to_inode, sara_task_to_inode),
> >  };
> [...]
> > +static int sara_file_open(struct file *file)
> > +{
> > +       struct task_struct *t;
> > +       struct mm_struct *mm;
> > +       u16 sara_wxp_flags = get_current_sara_wxp_flags();
> > +
> > +       /*
> > +        * Prevent write access to /proc/.../mem
> > +        * if it operates on the mm_struct of the
> > +        * current process: it could be used to
> > +        * bypass W^X.
> > +        */
> > +
> > +       if (!sara_enabled ||
> > +           !wxprot_enabled ||
> > +           !(sara_wxp_flags & SARA_WXP_WXORX) ||
> > +           !(file->f_mode & FMODE_WRITE))
> > +               return 0;
> > +
> > +       t = get_sara_inode_task(file_inode(file));
> > +       if (unlikely(t != NULL &&
> > +                    strcmp(file->f_path.dentry->d_name.name,
> > +                           "mem") == 0)) {
>
> This should probably at least have a READ_ONCE() somewhere in case the
> file concurrently gets renamed?

My understanding here is that /proc/$pid/mem files cannot be renamed.
t != NULL implies we are in procfs.
Under these assumptions I think that that code is fine.
Am I wrong?

> > +               get_task_struct(t);
> > +               mm = get_task_mm(t);
> > +               put_task_struct(t);
>
> Getting and dropping a reference to the task_struct here is completely
> useless. Either you have a reference, in which case you don't need to
> take another one, or you don't have a reference, in which case you
> also can't take one.

Absolutely agree.

> > +               if (unlikely(mm == current->mm))
> > +                       sara_warn_or_goto(error,
> > +                                         "write access to /proc/*/mem");
>
> Why is the current process so special that it must be protected more
> than other processes? Is the idea here to rely on other protections to
> protect all other tasks? This should probably come with a comment that
> explains this choice.

Yes, I should have spent some more words here.
Access to /proc/$pid/mem from other processes is already regulated by
security_ptrace_access_check (i.e. Yama).
Unfortunately, that hook is ignored when "mm == current->mm".
It seems that there is some user-space software that relies on /proc/self/mem
being writable (cfr. commit f511c0b17b08).

Thank you for your suggestions.
