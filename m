Return-Path: <SRS0=skYZ=XV=lists.openwall.com=kernel-hardening-return-16940-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF316C432C2
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 07:30:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1699F206E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 07:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="J3o94sis"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1699F206E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16940-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1158 invoked by uid 550); 26 Sep 2019 07:29:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1126 invoked from network); 26 Sep 2019 07:29:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pJTO0N8Sa0OjT2LYEstW960eNH5uDM9/jv6gM9eT9gk=;
        b=J3o94sis5s/AYYVg7jGtj9MzSdpCVQdRTONoyIFY7CEKI2KIXbaQLLeaIbtvfJL552
         BlCa507AkXEB5mH6xjWQsszs+kgZnvIo+z97Bra9cKV7k0dStzC8YVZoDqdbuw3GiUMy
         KE6XQTmLah8yDAhp0YIvXDEIpZO/yR9BX7F94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pJTO0N8Sa0OjT2LYEstW960eNH5uDM9/jv6gM9eT9gk=;
        b=dDpLZLpD6ATFWyqdnfoMAV923HYD60AAieI/420CNdTppxegYQZ2XU3V7XKF+TvI43
         1WnYo4BgzYzmU117FNxngkCTH2C2k4etj3EsVKf0qckN9DBnq/nB68j39rnmOkApJ7XK
         c/6G44Y0PBD/RLcEHiD1B0WUTIGhCuB0QOSwkuR63cJ9WnoSJ6eDzGlnbNHit6oAWi16
         91YusLrMDgNlbvuRVl+OsOytFscim/ZGAtkUb8HL1HbDN3GFCV0GD2lElRPBPl6XKLDw
         g/wHsI2454/vLZ8S1W7b+1EnwssadOdt3oyxPCv/haWczbupFJPzgIujyTGWEdMImJEh
         fqiQ==
X-Gm-Message-State: APjAAAWAeEtVIkZqBQh3G0mUKRozVjpzudj95IDkPs38kjxVKSLtY4Oc
	7g0AbkHn1kU3yjINAsWqt++SIA==
X-Google-Smtp-Source: APXvYqyP569ICpixYUvJYQnR5u2apBlb1tDGok6Cnvn7xn3RTAxSkBeEco+NWAzp56OMmHMILdHM/w==
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr1276805lfp.15.1569482986729;
        Thu, 26 Sep 2019 00:29:46 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
To: Stephen Kitt <steve@sk2.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com, kernel-hardening@lists.openwall.com,
 Takashi Iwai <tiwai@suse.com>, Clemens Ladisch <clemens@ladisch.de>,
 alsa-devel@alsa-project.org
References: <cover.1563889130.git.joe@perches.com>
 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
 <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
 <c0c2b8f6ac9f257b102b5a1a4b4dc949@sk2.org>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <8039728c-b41d-123c-e1ed-b35daac68fd3@rasmusvillemoes.dk>
Date: Thu, 26 Sep 2019 09:29:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c0c2b8f6ac9f257b102b5a1a4b4dc949@sk2.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 26/09/2019 02.01, Stephen Kitt wrote:
> Le 25/09/2019 23:50, Andrew Morton a écrit :
>> On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:
>>
>>> Several uses of strlcpy and strscpy have had defects because the
>>> last argument of each function is misused or typoed.
>>>
>>> Add macro mechanisms to avoid this defect.
>>>
>>> stracpy (copy a string to a string array) must have a string
>>> array as the first argument (dest) and uses sizeof(dest) as the
>>> count of bytes to copy.
>>>
>>> These mechanisms verify that the dest argument is an array of
>>> char or other compatible types like u8 or s8 or equivalent.
>>>
>>> A BUILD_BUG is emitted when the type of dest is not compatible.
>>>
>>
>> I'm still reluctant to merge this because we don't have code in -next
>> which *uses* it.  You did have a patch for that against v1, I believe?
>> Please dust it off and send it along?
> 
> Joe had a Coccinelle script to mass-convert strlcpy and strscpy.
> Here's a different patch which converts some of ALSA's strcpy calls to
> stracpy:

Please don't. At least not for the cases where the source is a string
literal - that just gives worse code generation (because gcc doesn't
know anything about strscpy or strlcpy), and while a run-time (silent)
truncation is better than a run-time buffer overflow, wouldn't it be
even better with a build time error?

Something like

/** static_strcpy - run-time version of static initialization
 *
 * @d: destination array, must be array of char of known size
 * @s: source, must be a string literal
 *
 * This is a simple wrapper for strcpy(d, s), which checks at build-time
that the strcpy() won't overflow. In most cases (for short strings), gcc
won't even emit a call to strcpy but rather just do a few immediate
stores into the destination, e.g.

   0:   c7 07 66 6f 6f 00       movl   $0x6f6f66,(%rdi)

 * for strcpy(d->name, "foo").
 */

#define static_strcpy(d, s) ({ \
  static_assert(__same_type(d, char[]), "destination must be char array"); \
  static_assert(__same_type(s, const char[], "source must be a string
literal"); \
  static_assert(sizeof(d) >= sizeof("" s ""), "source does not fit in
destination"); \
  strcpy(d, s); \
})

The "" s "" trick guarantees that s is a string literal - it probably
doesn't give a very nice error message, but that's why I added the
redundant type comparison to a const char[] which should hopefully give
a better clue.

Rasmus

PS: Yes, we already have a fortified strcpy(), but for some reason it
doesn't catch the common case where we're populating a char[] member of
some struct. So this

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e78017a3e1bd..3b0c5ae9f49e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -3420,3 +3420,14 @@ int sscanf(const char *buf, const char *fmt, ...)
        return i;
 }
 EXPORT_SYMBOL(sscanf);
+
+struct s { char name[4]; };
+char buf[4];
+void f3(void)
+{
+       strcpy(buf, "long");
+}
+void f4(struct s *s)
+{
+       strcpy(s->name, "long");
+}

with CONFIG_FORTIFY_SOURCE=y complains about f3(), but f4() is just fine...

PPS: A quick test of static_strcpy():

// ss.c
#include <errno.h>
#include <string.h>
#include <assert.h>

#define __same_type(x, y) __builtin_types_compatible_p(typeof(x), typeof(y))

#define static_strcpy(d, s) ({						\
  static_assert(__same_type(d, char[]), "destination must be char array"); \
  static_assert(__same_type(s, const char[]), "source must be a string
literal"); \
  static_assert(sizeof(d) >= sizeof("" s ""), "source does not fit in
destination"); \
  strcpy(d, s); \
})

struct s { char name[4]; };

void f0(struct s *s) { static_strcpy(s->name, "foo"); }
#if 1
void f1(struct s *s) { static_strcpy(s->name, strerror(EIO)); }
void f2(struct s *s) { static_strcpy(s->name, "long"); }
void f3(char *d) { static_strcpy(d, "foo"); }
void f4(char *d) { static_strcpy(d, strerror(EIO)); }
#endif

// gcc -Wall -O2 -o ss.o -c ss.c
In file included from ss.c:3:0:
ss.c: In function ‘f1’:
ss.c:9:3: error: static assertion failed: "source must be a string literal"
   static_assert(__same_type(s, const char[]), "source must be a string
literal"); \
   ^
ss.c:18:24: note: in expansion of macro ‘static_strcpy’
 void f1(struct s *s) { static_strcpy(s->name, strerror(EIO)); }
                        ^~~~~~~~~~~~~
ss.c:18:47: error: expected ‘)’ before ‘strerror’
 void f1(struct s *s) { static_strcpy(s->name, strerror(EIO)); }
                                               ^
ss.c:10:40: note: in definition of macro ‘static_strcpy’
   static_assert(sizeof(d) >= sizeof("" s ""), "source does not fit in
destination"); \
                                        ^
In file included from ss.c:3:0:
ss.c: In function ‘f2’:
ss.c:10:3: error: static assertion failed: "source does not fit in
destination"
   static_assert(sizeof(d) >= sizeof("" s ""), "source does not fit in
destination"); \
   ^
ss.c:19:24: note: in expansion of macro ‘static_strcpy’
 void f2(struct s *s) { static_strcpy(s->name, "long"); }
                        ^~~~~~~~~~~~~
ss.c: In function ‘f3’:
ss.c:8:3: error: static assertion failed: "destination must be char array"
   static_assert(__same_type(d, char[]), "destination must be char
array"); \
   ^
ss.c:20:20: note: in expansion of macro ‘static_strcpy’
 void f3(char *d) { static_strcpy(d, "foo"); }
                    ^~~~~~~~~~~~~
ss.c: In function ‘f4’:
ss.c:8:3: error: static assertion failed: "destination must be char array"
   static_assert(__same_type(d, char[]), "destination must be char
array"); \
   ^
ss.c:21:20: note: in expansion of macro ‘static_strcpy’
 void f4(char *d) { static_strcpy(d, strerror(EIO)); }
                    ^~~~~~~~~~~~~
ss.c:9:3: error: static assertion failed: "source must be a string literal"
   static_assert(__same_type(s, const char[]), "source must be a string
literal"); \
   ^
ss.c:21:20: note: in expansion of macro ‘static_strcpy’
 void f4(char *d) { static_strcpy(d, strerror(EIO)); }
                    ^~~~~~~~~~~~~
ss.c:21:37: error: expected ‘)’ before ‘strerror’
 void f4(char *d) { static_strcpy(d, strerror(EIO)); }
                                     ^
ss.c:10:40: note: in definition of macro ‘static_strcpy’
   static_assert(sizeof(d) >= sizeof("" s ""), "source does not fit in
destination"); \
                                        ^

