Return-Path: <SRS0=tE4U=BH=lists.openwall.com=kernel-hardening-return-19469-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18828C433F2
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 16:01:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6AF192078E
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 16:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLf3hUTw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AF192078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19469-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24517 invoked by uid 550); 28 Jul 2020 16:01:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24494 invoked from network); 28 Jul 2020 16:01:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595952097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Odxlq9Ln5GrmGx+aMPEKeiGZ+J1+ZE/sVWWvuPsLyGs=;
	b=DLf3hUTw4Ilb9SdLSGmAkL9FiXSInpd2TwwxpS5xnUb59zlT2BxIhHe3fLM7Ky8VlyEjXt
	7rMoqNpHjGcUtsZPPcwG66HhjjBA9DFdEYkZnAzJ6SO0Gt3hFnKn1EeOwPX3we3AWY8+M0
	app0GVp9s3gs3fqfPqEc/zThv7Ps0gI=
X-MC-Unique: 469_zStINx24Kcz1HIo-5w-1
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kees Cook <keescook@chromium.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>,
	Sargun Dhillon <sargun@sargun.me>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 1/3] io_uring: use an enumeration for io_uring_register(2) opcodes
Date: Tue, 28 Jul 2020 18:00:59 +0200
Message-Id: <20200728160101.48554-2-sgarzare@redhat.com>
In-Reply-To: <20200728160101.48554-1-sgarzare@redhat.com>
References: <20200728160101.48554-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

The enumeration allows us to keep track of the last
io_uring_register(2) opcode available.

Behaviour and opcodes names don't change.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7843742b8b74..efc50bd0af34 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -253,17 +253,22 @@ struct io_uring_params {
 /*
  * io_uring_register(2) opcodes and arguments
  */
-#define IORING_REGISTER_BUFFERS		0
-#define IORING_UNREGISTER_BUFFERS	1
-#define IORING_REGISTER_FILES		2
-#define IORING_UNREGISTER_FILES		3
-#define IORING_REGISTER_EVENTFD		4
-#define IORING_UNREGISTER_EVENTFD	5
-#define IORING_REGISTER_FILES_UPDATE	6
-#define IORING_REGISTER_EVENTFD_ASYNC	7
-#define IORING_REGISTER_PROBE		8
-#define IORING_REGISTER_PERSONALITY	9
-#define IORING_UNREGISTER_PERSONALITY	10
+enum {
+	IORING_REGISTER_BUFFERS,
+	IORING_UNREGISTER_BUFFERS,
+	IORING_REGISTER_FILES,
+	IORING_UNREGISTER_FILES,
+	IORING_REGISTER_EVENTFD,
+	IORING_UNREGISTER_EVENTFD,
+	IORING_REGISTER_FILES_UPDATE,
+	IORING_REGISTER_EVENTFD_ASYNC,
+	IORING_REGISTER_PROBE,
+	IORING_REGISTER_PERSONALITY,
+	IORING_UNREGISTER_PERSONALITY,
+
+	/* this goes last */
+	IORING_REGISTER_LAST
+};
 
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.26.2

