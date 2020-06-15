Return-Path: <SRS0=uN5Y=74=lists.openwall.com=kernel-hardening-return-18988-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD6DC433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 22:02:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E5BEA2071A
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 22:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5BEA2071A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ubuntu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18988-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1110 invoked by uid 550); 15 Jun 2020 22:02:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1090 invoked from network); 15 Jun 2020 22:02:13 -0000
Date: Tue, 16 Jun 2020 00:01:43 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
To: Jann Horn <jannh@google.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Sargun Dhillon <sargun@sargun.me>, Aleksa Sarai <asarai@suse.de>,
	Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>, io-uring <io-uring@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFC] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200615220143.qrm4ffbkpaew4xdv@wittgenstein>
References: <20200609142406.upuwpfmgqjeji4lc@steredhat>
 <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG48ez3kdNKjif==MbX36cKNYDpZwEPMZaJQ1rrpXZZjGZwbKw@mail.gmail.com>

On Mon, Jun 15, 2020 at 11:04:06AM +0200, Jann Horn wrote:
> +Kees, Christian, Sargun, Aleksa, kernel-hardening for their opinions
> on seccomp-related aspects

Just fyi, I'm on holiday this week so my responses have some
non-significant lag into early next week.

> 
> On Tue, Jun 9, 2020 at 4:24 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > Hi Jens,
> > Stefan and I have a proposal to share with io_uring community.
> > Before implementing it we would like to discuss it to receive feedbacks and
> > to see if it could be accepted:
> >
> > Adding restrictions to io_uring
> > =====================================
> > The io_uring API provides submission and completion queues for performing
> > asynchronous I/O operations. The queues are located in memory that is
> > accessible to both the host userspace application and the kernel, making it
> > possible to monitor for activity through polling instead of system calls. This
> > design offers good performance and this makes exposing io_uring to guests an
> > attractive idea for improving I/O performance in virtualization.
> [...]
> > Restrictions
> > ------------
> > This document proposes io_uring API changes that safely allow untrusted
> > applications or guests to use io_uring. io_uring's existing security model is
> > that of kernel system call handler code. It is designed to reject invalid
> > inputs from host userspace applications. Supporting guests as io_uring API
> > clients adds a new trust domain with access to even fewer resources than host
> > userspace applications.
> >
> > Guests do not have direct access to host userspace application file descriptors
> > or memory. The host userspace application, a Virtual Machine Monitor (VMM) such
> > as QEMU, grants access to a subset of its file descriptors and memory. The
> > allowed file descriptors are typically the disk image files belonging to the
> > guest. The memory is typically the virtual machine's RAM that the VMM has
> > allocated on behalf of the guest.
> >
> > The following extensions to the io_uring API allow the host application to
> > grant access to some of its file descriptors.
> >
> > These extensions are designed to be applicable to other use cases besides
> > untrusted guests and are not virtualization-specific. For example, the
> > restrictions can be used to allow only a subset of sqe operations available to
> > an application similar to seccomp syscall whitelisting.
> >
> > An address translation and memory restriction mechanism would also be
> > necessary, but we can discuss this later.
> >
> > The IOURING_REGISTER_RESTRICTIONS opcode
> > ----------------------------------------
> > The new io_uring_register(2) IOURING_REGISTER_RESTRICTIONS opcode permanently
> > installs a feature whitelist on an io_ring_ctx. The io_ring_ctx can then be
> > passed to untrusted code with the knowledge that only operations present in the
> > whitelist can be executed.
> 
> This approach of first creating a normal io_uring instance and then
> installing restrictions separately in a second syscall means that it
> won't be possible to use seccomp to restrict newly created io_uring
> instances; code that should be subject to seccomp restrictions and
> uring restrictions would only be able to use preexisting io_uring
> instances that have already been configured by trusted code.
> 
> So I think that from the seccomp perspective, it might be preferable
> to set up these restrictions in the io_uring_setup() syscall. It might

So from what I can gather from this proposal, this would be a separate
security model for io_uring? I'm not to thrilled about that tbh. (There's
some discussion around extending seccomp - also at kernel summit.)
But doing the whole restriction setup in io_uring_setup() would at least
mean that if seccomp is extended to filter first-level pointers it could
know about all the security restrictions that apply to this io_uring
instance (Which I think you were getting at, Jann?).

Hm, would it make sense that if a task has a seccomp filter installed
that blocks openat syscalls that io_uring should automatically block
openat() calls as well or is the expectation "just block all of io_uring
if you're worried about that"?

Christian
