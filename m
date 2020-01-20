Return-Path: <SRS0=VDg/=3J=lists.openwall.com=kernel-hardening-return-17593-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70496C33CB8
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B8CCB2465B
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="k+UiYYHG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8CCB2465B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17593-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18298 invoked by uid 550); 20 Jan 2020 07:44:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18262 invoked from network); 20 Jan 2020 07:44:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6YkuZ8tp2wmCPxdpgMXItiYj736TUwlM7992jMev2hM=;
        b=k+UiYYHG/v+VJD/4zWr69Wkd6H+h5loGovze3xLnJFbvL7nXcqhcsBh3ieanqlchRQ
         jcG9Xv5AvZxJ/UXVHazQgMkBxNtnZELVWNUt27L+7mDr53+M2Yan5mS45jhpnJa/NRZz
         v1nM8OE/bwDqVj/nZcOPD1br0C8bHAa892PKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6YkuZ8tp2wmCPxdpgMXItiYj736TUwlM7992jMev2hM=;
        b=KXxTmGQZdSS8HgpiThoB2ss2FPS0W5QEoRTUQpD8EK+54fs34bHsGJa29vFsub9AMm
         +H9oHGVOFHbGBv9N2xhFHA7BmHzA3xkMcBCu9pV04MutwpvDS9pabsUB09cZQ4axKO9k
         xvTaHEjJzCMlEPwGLGwnDi3bU6qzmihvYPx8ja2qUYcMPXRFxikV6bAA0ENBsOtye9VB
         tfpfSrieKSTpdnj5G6KzaSppDOpu/iWpwGv3rTKkAf/HqYeA48LwrDLTJ+/ozI4B3xoF
         /17gQp5o87tWykskgY8WH5rBOkeI+NtCufEO1+IYKim2fQQFaXZwfluie6W7QlKB8Bcl
         GGAw==
X-Gm-Message-State: APjAAAWpzTSiQl28Lc1lp50OckIgNHng7tYJ78wRApZtzdZaVD4WZ2LU
	XiLXTdBLRxMMgBOvQZy/sOyKTOF/eYQ=
X-Google-Smtp-Source: APXvYqx6WIelXXQ1XxBQSJPB9fvVEwMpFGLYN0Oq9eHgf6RjMRe6JDnsTVkTumU89S7sClpvNsw8dQ==
X-Received: by 2002:a17:902:b704:: with SMTP id d4mr12873725pls.54.1579506229307;
        Sun, 19 Jan 2020 23:43:49 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Daniel Axtens <dja@axtens.net>
Subject: [PATCH 0/5] Annotate allocation functions with alloc_size attribute
Date: Mon, 20 Jan 2020 18:43:39 +1100
Message-Id: <20200120074344.504-1-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Both gcc and clang support the 'alloc_size' function attribute. It tells
the compiler that a function returns a pointer to a certain amount of
memory.

This series tries applying that attribute to a number of our memory
allocation functions. This provides much more information to things that
use __builtin_object_size() (FORTIFY_SOURCE and some copy_to/from_user
stuff), as well as enhancing inlining opportunities where __builtin_mem* or
__builtin_str* are used.

With this series, FORTIFY_SOURCE picks up a bug in altera-stapl, which is
fixed in patch 1.

It also generates a bunch of warnings about times memory allocation
functions can be called with SIZE_MAX as the parameter. For example, from
patch 3:

drivers/staging/rts5208/rtsx_chip.c: In function ‘rtsx_write_cfg_seq’:
drivers/staging/rts5208/rtsx_chip.c:1453:7: warning: argument 1 value ‘18446744073709551615’ exceeds maximum object size 9223372036854775807 [-Walloc-size-larger-than=]
  data = vzalloc(array_size(dw_len, 4));
  ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The parameter to array_size is a size_t, but it is called with a signed
integer argument. If the argument is a negative integer, it will become a
very large positive number when cast to size_t. This could cause an
overflow, so array_size() will return SIZE_MAX _at compile time_. gcc then
notices that this value is too large for an allocation and throws a
warning.

I propose two ways to deal with this:

 - Individually go through and address these warnings, usualy by
   catching when struct_size/array_size etc are called with a signed
   type, and insert bounds checks or change the type where
   appropriate. Patch 3 is an example.

 - Patch 4: make kmalloc(_node) catch SIZE_MAX and return NULL early,
   preventing an annotated kmalloc-family allocation function from seeing
   SIZE_MAX as a parameter.

I'm not sure whether I like the idea of catching SIZE_MAX in the inlined
functions. Here are some pros and cons, and I'd be really interested to
hear feedback:

 * Making kmalloc return NULL early doesn't change _runtime_ behaviour:
   obviously no SIZE_MAX allocation will ever succeed. And it means we
   could have this feature earlier, which will help to catch issues like
   what we catch in altera-stapl.

 * However, it does mean we don't audit callsites where perhaps we should
   have stricter types or bounds-checking. It also doesn't cover any of the
   v*alloc functions.

Overall I think this is a meaningful strengthening of FORTIFY_SOURCE
and worth pursuing.

Daniel Axtens (5):
  altera-stapl: altera_get_note: prevent write beyond end of 'key'
  [RFC] kasan: kasan_test: hide allocation sizes from the compiler
  [RFC] staging: rts5208: make len a u16 in rtsx_write_cfg_seq
  [VERY RFC] mm: kmalloc(_node): return NULL immediately for SIZE_MAX
  [RFC] mm: annotate memory allocation functions with their sizes

 drivers/misc/altera-stapl/altera.c  | 12 ++++----
 drivers/staging/rts5208/rtsx_chip.c |  2 +-
 drivers/staging/rts5208/rtsx_chip.h |  2 +-
 include/linux/compiler_attributes.h |  6 ++++
 include/linux/kasan.h               | 12 ++++----
 include/linux/slab.h                | 44 +++++++++++++++++---------
 include/linux/vmalloc.h             | 26 ++++++++--------
 lib/test_kasan.c                    | 48 +++++++++++++++++++++--------
 8 files changed, 98 insertions(+), 54 deletions(-)

-- 
2.20.1

