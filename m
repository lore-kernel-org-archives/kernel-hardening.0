Return-Path: <SRS0=hmHU=AV=lists.openwall.com=kernel-hardening-return-19278-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73508C433E8
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 14:20:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C961620674
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Jul 2020 14:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vlpha8W+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C961620674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19278-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9844 invoked by uid 550); 10 Jul 2020 14:20:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9820 invoked from network); 10 Jul 2020 14:20:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594390801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S/hfdY2jn078JPQClgP6PouoRBDjiWkYV+fASuPUqJA=;
	b=Vlpha8W+gfVSUDC8sJdYzNMYLSJbDGwtrnPJ1dIvei+SFgUNTxb/9rQJ7/2dDegtVprlf6
	Cn9TVwZF+8TgvegnCilmVTSlqK9NxdGE/1QUt2EDDlSLbGeZRHvzpEeMvRAX+Xgib02tdR
	XO8q0aTjWi+KGitg8Bt04X1daD5hBjA=
X-MC-Unique: Ur_35eYIO8ykayRn1yNGQw-1
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>,
	Aleksa Sarai <asarai@suse.de>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date: Fri, 10 Jul 2020 16:19:42 +0200
Message-Id: <20200710141945.129329-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

Following the proposal that I send about restrictions [1], I wrote a PoC with
the main changes. It is still WiP so I left some TODO in the code.

I also wrote helpers in liburing and a test case (test/register-restrictions.c)
available in this repository:
https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Just to recap the proposal, the idea is to add some restrictions to the
operations (sqe, register, fixed file) to safely allow untrusted applications
or guests to use io_uring queues.

The first patch changes io_uring_register(2) opcodes into an enumeration to
keep track of the last opcode available.

The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
handle restrictions.

The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
allowing the user to register restrictions, buffers, files, before to start
processing SQEs.
I'm not sure if this could help seccomp. An alternative pointed out by Jann
Horn could be to register restrictions during io_uring_setup(2), but this
requires some intrusive changes (there is no space in the struct
io_uring_params to pass a pointer to restriction arrays, maybe we can add a
flag and add the pointer at the end of the struct io_uring_params).

Another limitation now is that I need to enable every time
IORING_REGISTER_ENABLE_RINGS in the restrictions to be able to start the rings,
I'm not sure if we should treat it as an exception.

Maybe registering restrictions during io_uring_setup(2) could solve both issues
(seccomp integration and IORING_REGISTER_ENABLE_RINGS registration), but I need
some suggestions to properly extend the io_uring_setup(2).

Comments and suggestions are very welcome.

Thank you in advance,
Stefano

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 155 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  59 ++++++++++---
 2 files changed, 194 insertions(+), 20 deletions(-)

-- 
2.26.2

