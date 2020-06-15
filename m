Return-Path: <SRS0=kCZg=74=lists.openwall.com=kernel-hardening-return-18972-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD0CC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:04:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6123D2065F
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ixfqp8u8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6123D2065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18972-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7853 invoked by uid 550); 15 Jun 2020 09:04:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7833 invoked from network); 15 Jun 2020 09:04:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7Vksm3yVsusCZGLEEjTvbEqPOS/06Z5wknpkPUtdlk=;
        b=Ixfqp8u8Rl69K6PKy1mGZQOiZmh0ZJEtQdb7NAeRQuN3byG4vcJX1x3182X8EWE6jI
         ctSYCsBiVysxQAFCxd2JbwmFPvsqu3ZdcXcRN4V1DTf7L6tvIlfYH4vkACTrGWYux+o4
         ZJG4mM/covrF4jrDg4ZHg2luZQ7epBMJvYdbsRSPDEUOC2OufyZ00Jrar6HZvhcc+YkS
         XleRd6bSGFkUqu/0q4SekjyF2ywdF7PVg+a5z4xf38yMOVfsya8nM6sGlFC2AyMl/0lV
         CaNRl4a4oQq08sLtbDyGRTDjS6sgUpMCVNtpYDG+qRofp+ueNkYwxjqOPJHIRH4Wgjvs
         ugOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7Vksm3yVsusCZGLEEjTvbEqPOS/06Z5wknpkPUtdlk=;
        b=Cz78v4plpj1k+wWFzndxbJQsMqZeYbXQQ0vVXcXL4Rvj/uleCOPDOLNjQsnq2fSwU9
         aNI267fnACS/pHh2DVwFdiUE4dMzhHZ9GOlgsigMSqHBTK/vVelcMhz+aaUlJT/BYqGS
         HaSa9OscMJuJNQeZm4sOtxhal7PhX9jGzUwtcdBzzRObXr32YNu/VDQpDyk3RZ4MgApb
         /A0bTjm5ie3tP2hX5lx0UWQuxTExDYPeh+W4MY7yhOsaMCO6gaXixp3ehJuDLOlw33qe
         gwt/GTshK+Vdtk0Fkd4qg37JoeJXe9Co75btTdHJp8uDii7q1v7/BSDkAyRyOA92FL4l
         r67Q==
X-Gm-Message-State: AOAM530qdF1wRvYATZ+jNpRJElaCO37KeMOGjgRpOJX8it8Ijk9b0Sgl
	hhFQ/xg1heRB7mq0AmkgcM01meGjcavofSor7M2BJA==
X-Google-Smtp-Source: ABdhPJzk8pDwMUC1U4/hmyURlQzg8+VVDMlW+27NBx3jZLR+glDX42DgRR9QPDbR/Oz7srTuWj/giUBnVQDOSQLim9U=
X-Received: by 2002:a19:a405:: with SMTP id q5mr12790536lfc.164.1592211872518;
 Mon, 15 Jun 2020 02:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200609142406.upuwpfmgqjeji4lc@steredhat>
In-Reply-To: <20200609142406.upuwpfmgqjeji4lc@steredhat>
From: Jann Horn <jannh@google.com>
Date: Mon, 15 Jun 2020 11:04:06 +0200
Message-ID: <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
To: Stefano Garzarella <sgarzare@redhat.com>, Kees Cook <keescook@chromium.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Sargun Dhillon <sargun@sargun.me>, 
	Aleksa Sarai <asarai@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, 
	io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

+Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
on seccomp-related aspects

On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> Hi Jens,
> Stefan and I have a proposal to share with io_uring community.
> Before implementing it we would like to discuss it to receive feedbacks and
> to see if it could be accepted:
>
> Adding restrictions to io_uring
> =====================================
> The io_uring API provides submission and completion queues for performing
> asynchronous I/O operations. The queues are located in memory that is
> accessible to both the host userspace application and the kernel, making it
> possible to monitor for activity through polling instead of system calls. This
> design offers good performance and this makes exposing io_uring to guests an
> attractive idea for improving I/O performance in virtualization.
[...]
> Restrictions
> ------------
> This document proposes io_uring API changes that safely allow untrusted
> applications or guests to use io_uring. io_uring's existing security model is
> that of kernel system call handler code. It is designed to reject invalid
> inputs from host userspace applications. Supporting guests as io_uring API
> clients adds a new trust domain with access to even fewer resources than host
> userspace applications.
>
> Guests do not have direct access to host userspace application file descriptors
> or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> as QEMU, grants access to a subset of its file descriptors and memory. The
> allowed file descriptors are typically the disk image files belonging to the
> guest. The memory is typically the virtual machine's RAM that the VMM has
> allocated on behalf of the guest.
>
> The following extensions to the io_uring API allow the host application to
> grant access to some of its file descriptors.
>
> These extensions are designed to be applicable to other use cases besides
> untrusted guests and are not virtualization-specific. For example, the
> restrictions can be used to allow only a subset of sqe operations available to
> an application similar to seccomp syscall whitelisting.
>
> An address translation and memory restriction mechanism would also be
> necessary, but we can discuss this later.
>
> The IOURING_REGISTER_RESTRICTIONS opcode
> ----------------------------------------
> The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> passed to untrusted code with the knowledge that only operations present in the
> whitelist can be executed.

This approach of first creating a normal io_uring instance and then
installing restrictions separately in a second syscall means that it
won't be possible to use seccomp to restrict newly created io_uring
instances; code that should be subject to seccomp restrictions and
uring restrictions would only be able to use preexisting io_uring
instances that have already been configured by trusted code.

So I think that from the seccomp perspective, it might be preferable
to set up these restrictions in the io_uring_setup() syscall. It might
also be a bit nicer from a code cleanliness perspective, since you
won't have to worry about concurrently changing restrictions.
