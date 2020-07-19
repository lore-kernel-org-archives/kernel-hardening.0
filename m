Return-Path: <SRS0=JMsX=A6=lists.openwall.com=kernel-hardening-return-19393-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02230C433E2
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Jul 2020 15:52:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 58C98207EA
	for <kernel-hardening@archiver.kernel.org>; Sun, 19 Jul 2020 15:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ZTNJnNSn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58C98207EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19393-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8069 invoked by uid 550); 19 Jul 2020 15:51:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8049 invoked from network); 19 Jul 2020 15:51:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595173872;
	bh=II5cHQCwfPee86KSUefTyAwEuMywfdmgqOhgIYjQV6w=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=ZTNJnNSnR5692hlzt+RMrAgyMmLHXoZ9XZQsejfJ96mvL/siseUnYtDixg61nUAeM
	 tcpJA3JJpyaXtsyvhMpn1aqWr8U1lK4mkCNi+FQf83sIVRL03bRj3dU9eiYYV5Wy10
	 r+1r6zMJkQCMnGS7x4K0yjugbJm/lgKRxnZPpt5I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 0/2] kernel/trace: Remove function callback casts
Date: Sun, 19 Jul 2020 17:50:31 +0200
Message-Id: <20200719155033.24201-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PAJKW7m3+NEkL7h7V0Z7LnFNinjyjbDH70fHBDbofLsjc/8YDFI
 Cz04NdXc/Iqx/cLnMwjSPwakkQbi+pCzA1WJc6Q2GB3Npjsee+o5sDqqQAQ1yGlvLT1G3Lz
 K7VTaGX+x1S0wu2DwaZecE4C5YKtLfdyC+fLhu9YSMmZiehWgB8k6dLLgMKx7NBXWtNkiVY
 BhiNRZjR1nXnKVRMQ/CDg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:luPXm42dGBo=:aV0F9ngfFkJGJ1UG2XfZyq
 EDW/iq0MJ8kOVclatXcmLBexnYxouiaayARfVGKKxKCRiaCOktSq7YwToHqzcXO/2XyK0DpoH
 mZ8a2/OkkTItskUxqKLpdvSMk2UBuvrixEd6AjJAIaqt6Ny2+N4bxg34UjY83fC0d1yyKmguS
 P/NUcthyjXxqW7FX1BAHkP88CObHVzwsVb8CgpNxGvH5Mhfhg6eyyaZ7KyWqx2bL53+2r+MPR
 4Ff3bmiia8f5IxO1szfp6YdTKeaqPrE8vPsr3G1F+zTyFG7lRpaA9Wkh3znhzlBXNhBCAObVh
 0p1XU5ikproy9d6SCeBzZccRkhntODBZ8B0MTgVjx/sS5gs4LQQG9YlbqAkaKXGSnE80E328g
 DyRIkuXob/HCkDaoUEEvqJvMMTErwyp6+N6uXhoN3IHR2kp/b9TcwJY0Hc7wVpVNdy4VR0lVk
 pSBMWRc+TKQism4Mz5+zGOAlN3LwG1fYpV/1BUIVMmgNVnsNmAiopRi1Gy3rMdxRUSa/7Ma3q
 hVIz4S1pNyVWe5OyaX0yRxb1Uzt0uTcK8YYLgAbXL/BfIT3D8eUVPAvxKHHlPJXTYjcjs4a5h
 WG20PvRtD+q7nNI8cA62kBHIFIKFZXiWZyg692SvIO/GSJGMMSK9pyc0dcFylifwYJSWeMt8K
 0U1OqzSNmhynNd2q54Jy7SwcxLqQFqFD/RM5VFWgI6u4LblypqcJKLQ5NNzjv9Dxd5BErNCe4
 OfW8lP3t6Tid9g8P3Tq8iNxC4mcUe71pR/RCr9uBNov+efbr0Mz5j6L3U8X5D82P3VTnqR4S/
 BfJCuWcqm1gPM1EagjhCQM+QGE9X2p47apC6NkeiO7zHM5Y3oikZsMZIYMz9o13RBvJje5Kyu
 7IORDI0qs0gMd+V0klV44sV6QKc70eF3c8SZor6cxnnVjunoJe//qYRtlB2EYdx8xTshALVqD
 cOhHRzyePwEZvdCYJJj/XXQh0aPHWXBwNpWpczyCj85+2XFa328VrnWaBC1I3V3ILYzVL17EY
 vchEZl1jloJzBMQ4UEHYigHMyn3h+SnfliyV1aEfgp+AXEX9My+8dwlOJpZ0NK3U5zsn+D7fE
 z+TjdG9fbQ0r46eXARu8tvaZVHQVSrvLqhMLUJJ0GuoLxUnc6BodSA1qrP9IwiAJJ/wNqTfnG
 lOUCxtpm6+hP20OlzvGFpq1T9yqZ6kpCs0u9/khgq4lT66A/rROKnQHGTYq95XQ0HBe1Z7kkF
 Rl+jrCPVp2rFr6kfe7Hz5lz29S+2ox+sZFDmVWg==

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, there are the need to remove all
the function callback casts.

ftrace_ops_list_func() can no longer be defined as ftrace_ops_no_ops().
The reason for ftrace_ops_no_ops() is to use that when an architecture
calls ftrace_ops_list_func() with only two parameters (called from
assembly). And to make sure there's no C side-effects, those archs call
ftrace_ops_no_ops() which only has two parameters, as the function
ftrace_ops_list_func() has four parameters.

This patch series is a new proposal for the work start by me [1] and
followed by the Steven Rostedt patch [2] and Jann Horn comments [3].

This new proposal removes all the function callback casts without the
use of linker magic and so is more CFI friendly.

The first patch prepares the needed infrastructure to remove all the
function callback casts. This infrastructure is based in a new union
type to manage two different function pointers (2 parameters and 4
parameters) using the same variable. Also create two static inline
helpers to set and compare against the fields of the new union type.
The helpers are duplicated for the archs that support ftrace ops and
for the archs that don't support ftrace ops as both cases use different
function prototypes.

The second patch removes all the function callback casts using the
infrastructure defined previously in the first patch.

[1] https://lore.kernel.org/kernel-hardening/20200614070154.6039-1-oscar.c=
arter@gmx.com/
[2] https://lore.kernel.org/kernel-hardening/20200617165616.52241bde@oasis=
.local.home/
[3] https://lore.kernel.org/kernel-hardening/CAG48ez04Fj=3D1p61KAxAQWZ3f_z=
073fVUr8LsQgtKA9c-kcHmDQ@mail.gmail.com/

Changelog v1->v2
-Discard the idea behind the v1 patch.
-Use a new union type to manage two different function pointers.
-Create the infrastructure to remove the casts.
-Remove the casts using the new infrastructure.

Oscar Carter (2):
  kernel/trace: Prepare to remove function callback casts
  kernel/trace: Remove function callback casts

 kernel/trace/ftrace.c | 80 +++++++++++++++++++++++++++++++++----------
 1 file changed, 61 insertions(+), 19 deletions(-)

=2D-
2.20.1

