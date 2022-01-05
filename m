Return-Path: <kernel-hardening-return-21528-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id D5402C433F5
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Jan 2022 16:04:20 +0000 (UTC)
Received: (qmail 7340 invoked by uid 550); 5 Jan 2022 16:04:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7234 invoked from network); 5 Jan 2022 16:03:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641398616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hkde+7eKZjv80qwsVvmCX2T7y8AoaKGRyE5+tZVJ4q0=;
	b=UfvotGERhK03kSMVqzkAb3T1aeBE5eyTgHOhyIlJA//JJkYvUlMacCm8xlWQnpT5OenmiF
	glXYHIvIoezVTl9rQ4ux/v1hjNxrLmnxf6dgbNxW9gGJdvIgu3PxtzWtLUPKuOctYFPVXs
	01FdNoHtT6RF+7SanpzAXH/cr5kpooE=
X-MC-Unique: b7RAR5SOOa-mxTpn4XvsZw-1
From: Florian Weimer <fweimer@redhat.com>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,
        "Linux API" <linux-api@vger.kernel.org>,
        linux-x86_64@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, "the arch/x86 maintainers" <x86@kernel.org>,
        musl@lists.openwall.com, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Kees Cook" <keescook@chromium.org>, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v3 2/3] selftests/x86/Makefile: Support per-target $(LIBS)
 configuration
In-Reply-To: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
X-From-Line: 54ae0e1f8928160c1c4120263ea21c8133aa3ec4 Mon Sep 17 00:00:00 2001
Message-Id: <54ae0e1f8928160c1c4120263ea21c8133aa3ec4.1641398395.git.fweimer@redhat.com>
Date: Wed, 05 Jan 2022 17:03:15 +0100
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

And avoid compiling PCHs by accident.

Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
v3: Patch split out.

 tools/testing/selftests/x86/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 8a1f62ab3c8e..0993d12f2c38 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -72,10 +72,12 @@ all_64: $(BINARIES_64)
 EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
 
 $(BINARIES_32): $(OUTPUT)/%_32: %.c helpers.h
-	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl -lm
+	$(CC) -m32 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h, $^) \
+		$(or $(LIBS), -lrt -ldl -lm)
 
 $(BINARIES_64): $(OUTPUT)/%_64: %.c helpers.h
-	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $^ -lrt -ldl
+	$(CC) -m64 -o $@ $(CFLAGS) $(EXTRA_CFLAGS) $(filter-out %.h, $^) \
+		$(or $(LIBS), -lrt -ldl -lm)
 
 # x86_64 users should be encouraged to install 32-bit libraries
 ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
-- 
2.33.1


