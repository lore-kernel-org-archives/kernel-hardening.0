Return-Path: <SRS0=S+OM=CF=lists.openwall.com=kernel-hardening-return-19702-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C533C433E3
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:59:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 60E6322B4B
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUB4mNqp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60E6322B4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19702-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12166 invoked by uid 550); 27 Aug 2020 14:58:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12143 invoked from network); 27 Aug 2020 14:58:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598540323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hzfczoY08KCAOXrJ4QPUBcOl3kLlAqwyM9dLVlxgAlg=;
	b=XUB4mNqpQVGX1lJOTw7ArMwptRJKdM8lobpXI/acVB9WOQX4mUptM1HhIKECvN5IoS89nq
	DstFmxawp/RVa/5fEgiICJWEsvkK2pRX+xRBQNF/gRoZ0T0Aj0h6rze2JZlFLVGIdCkZyN
	8nXnCITRriEBwucli6TqjO6JeO3NQEE=
X-MC-Unique: OgZhy-oMOZaq0ggeHWE2Pg-1
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Aleksa Sarai <asarai@suse.de>,
	Sargun Dhillon <sargun@sargun.me>,
	linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date: Thu, 27 Aug 2020 16:58:28 +0200
Message-Id: <20200827145831.95189-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

v6:
 - moved restriction checks in a function [Jens]
 - changed ret value handling in io_register_restrictions() [Jens]

v5: https://lore.kernel.org/io-uring/20200827134044.82821-1-sgarzare@redhat.com/
v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com

Following the proposal that I send about restrictions [1], I wrote this series
to add restrictions in io_uring.

I also wrote helpers in liburing and a test case (test/register-restrictions.c)
available in this repository:
https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Just to recap the proposal, the idea is to add some restrictions to the
operations (sqe opcode and flags, register opcode) to safely allow untrusted
applications or guests to use io_uring queues.

The first patch changes io_uring_register(2) opcodes into an enumeration to
keep track of the last opcode available.

The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
handle restrictions.

The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
allowing the user to register restrictions, buffers, files, before to start
processing SQEs.

Comments and suggestions are very welcome.

Thank you in advance,
Stefano

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 172 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  60 +++++++++---
 2 files changed, 215 insertions(+), 17 deletions(-)

-- 
2.26.2

