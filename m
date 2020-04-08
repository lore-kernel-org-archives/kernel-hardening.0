Return-Path: <SRS0=DXUK=5Y=lists.openwall.com=kernel-hardening-return-18464-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EB4C2D0F4
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Apr 2020 22:27:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AFD6120753
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Apr 2020 22:27:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jt4UEb08"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFD6120753
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18464-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16090 invoked by uid 550); 8 Apr 2020 22:27:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16067 invoked from network); 8 Apr 2020 22:27:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0IxhJthYzoFGzHPRNJEuwsAmGxzG5+XUgsaLtHukDmo=;
        b=Jt4UEb08cWeiS20+2wlm3OhfNdeq68MS15GaeQ7aBN6rERE2M6pKSwmxcdCu2CIxAd
         Nsb/9hmyaCIptWmS7Q8wVxdaWRIKVTd3NnESPyzok7t6R0iYUhjZnD/+WFPEd7D+EQkp
         k7561fyi3XD5Bf5R0FqG5Jii6fTBO5eH68o9bwYiHvbjhTm4xS1G0WNSNXlFWubhWpxv
         yNdaUvOI3XtWwuvJfoJhwPSEyvrEpRLxLIBADqcFX/2dwr4Gvb0SNJ8yI0rNUkdo+fNL
         cRfDeJB6G2RtRBTurl4ijWTPuSAN501p4bPgj2e8IkIxRrZZAKQrmD7JI0mRQxK1OeLS
         LYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0IxhJthYzoFGzHPRNJEuwsAmGxzG5+XUgsaLtHukDmo=;
        b=Hp7lTjrZENKs7LvB9+zVhvb5PGcI8zqPxqe4GON4D6xATSNuMHxD8u2+b1TKF0fv3s
         hUqi+25ymi6V+HDJ5e38uaJQwu0jqdrvsK8rHjgpamPn3WAxD1tK0jXYIbL0LWz5njrG
         fqvG6jnOQMmVniuH2R5aqgtj1Ewam4uYcGK7eDyMadQeOTBlCj2xY2d6hqI0hByrHUgs
         24T9cm6yv+3h88xvLg3EzgtpCD0i5zbNpPqmbK/7gqNLSExD6VTwbE90YCbgd5TIh0cH
         e51JTsII6+rpYEJ96zm2GVliTBikCoTpFKka8U92g+wcjHM576ipnF6IJDreZOtTR8QP
         uAmw==
X-Gm-Message-State: AGi0PuaP/HYGDEgigq120hWEpeANYBryt/ZcFgHjXEDyBnZ3WLATsIlT
	laPy3hGoeKGt+/1hXDVRPTczD5X+F4H4sGu4dT3bdA==
X-Google-Smtp-Source: APiQypKw3pUMTJPpu9PX8DKDTel9965lGRN2jMKefg+mFHDV23V0n9xzRSOYGpKDCRGHdJbIYIRbz0DZDEi2uCjq5Uc=
X-Received: by 2002:a2e:9247:: with SMTP id v7mr5980354ljg.215.1586384835570;
 Wed, 08 Apr 2020 15:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <fff664e9-06c9-d2fb-738f-e8e591e09569@linux.com>
In-Reply-To: <fff664e9-06c9-d2fb-738f-e8e591e09569@linux.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 9 Apr 2020 00:26:49 +0200
Message-ID: <CAG48ez09gn1Abv-EwwW5Rgjqo2CQsbq6tjDeTfpr_FnJC7f5zA@mail.gmail.com>
Subject: Re: Coccinelle rule for CVE-2019-18683
To: Alexander Popov <alex.popov@linux.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>, 
	Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <michal.lkml@markovi.net>, cocci@systeme.lip6.fr, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, 
	Hans Verkuil <hverkuil@xs4all.nl>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Linux Media Mailing List <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 9, 2020 at 12:01 AM Alexander Popov <alex.popov@linux.com> wrote:
> CVE-2019-18683 refers to three similar vulnerabilities caused by the same
> incorrect approach to locking that is used in vivid_stop_generating_vid_cap(),
> vivid_stop_generating_vid_out(), and sdr_cap_stop_streaming().
>
> For fixes please see the commit 6dcd5d7a7a29c1e4 (media: vivid: Fix wrong
> locking that causes race conditions on streaming stop).
>
> These three functions are called during streaming stopping with vivid_dev.mutex
> locked. And they all do the same mistake while stopping their kthreads, which
> need to lock this mutex as well. See the example from
> vivid_stop_generating_vid_cap():
>     /* shutdown control thread */
>     vivid_grab_controls(dev, false);
>     mutex_unlock(&dev->mutex);
>     kthread_stop(dev->kthread_vid_cap);
>     dev->kthread_vid_cap = NULL;
>     mutex_lock(&dev->mutex);
>
> But when this mutex is unlocked, another vb2_fop_read() can lock it instead of
> the kthread and manipulate the buffer queue. That causes use-after-free.
>
> I created a Coccinelle rule that detects mutex_unlock+kthread_stop+mutex_lock
> within one function.
[...]
> mutex_unlock@unlock_p(E)
> ...
> kthread_stop@stop_p(...)
> ...
> mutex_lock@lock_p(E)

Is the kthread_stop() really special here? It seems to me like it's
pretty much just a normal instance of the "temporarily dropping a
lock" pattern - which does tend to go wrong quite often, but can also
be correct.

I think it would be interesting though to have a list of places that
drop and then re-acquire a mutex/spinlock/... that was not originally
acquired in the same block of code (but was instead originally
acquired in an outer block, or by a parent function, or something like
that). So things like this:

void X(...) {
  mutex_lock(A);
  for (...) {
    ...
    mutex_unlock(A);
    ...
    mutex_lock(A);
    ...
  }
  mutex_unlock(A);
}

or like this:

void X(...) {
  ... [no mutex operations on A]
  mutex_unlock(A);
  ...
  mutex_lock(A);
  ...
}


But of course, there are places where this kind of behavior is
correct; so such a script wouldn't just return report code, just code
that could use a bit more scrutiny than normal. For example, in
madvise_remove(), the mmap_sem is dropped and then re-acquired, which
is fine because the caller deals with that possibility properly:

static long madvise_remove(struct vm_area_struct *vma,
                                struct vm_area_struct **prev,
                                unsigned long start, unsigned long end)
{
        loff_t offset;
        int error;
        struct file *f;

        *prev = NULL;   /* tell sys_madvise we drop mmap_sem */

        if (vma->vm_flags & VM_LOCKED)
                return -EINVAL;

        f = vma->vm_file;

        if (!f || !f->f_mapping || !f->f_mapping->host) {
                        return -EINVAL;
        }

        if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
                return -EACCES;

        offset = (loff_t)(start - vma->vm_start)
                        + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);

        /*
         * Filesystem's fallocate may need to take i_mutex.  We need to
         * explicitly grab a reference because the vma (and hence the
         * vma's reference to the file) can go away as soon as we drop
         * mmap_sem.
         */
        get_file(f);
        if (userfaultfd_remove(vma, start, end)) {
                /* mmap_sem was not released by userfaultfd_remove() */
                up_read(&current->mm->mmap_sem);
        }
        error = vfs_fallocate(f,
                                FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
                                offset, end - start);
        fput(f);
        down_read(&current->mm->mmap_sem);
        return error;
}
