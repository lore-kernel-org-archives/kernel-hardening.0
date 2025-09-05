Return-Path: <kernel-hardening-return-22002-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id C8CAECA1017
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Sep 2025 20:11:35 +0000 (UTC)
Received: (qmail 7975 invoked by uid 550); 5 Sep 2025 20:11:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7937 invoked from network); 5 Sep 2025 20:11:23 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757103075; x=1757707875;
        h=content-transfer-encoding:subject:from:to:content-language:reply-to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3CNeVBChpPSW3Zw9eLsrTWLPrHpK+4pxoexsckxOXIg=;
        b=raoenSvwyCSdXd2R2RtWDoO5xq1vQJSAxs5+VWhJoOnOzB9T7gykEor4gMMBHQ8+UC
         TN+jmWvppyvReOLAn741F6RFzMwDVAVbiJD8RE5O2tSo88pMaiA2cxunIwzWy+X31qhU
         yCYl00mErL4rwpCMRrcrlwIHgWXhbDb4P8Pm2RIfv5gVFXvLfZex7WaA6KRErvxbWDcT
         lyd0w0xApqBOfXvjO4XAiPWlpsM0cUVcSZzWh1+jrwLjcDwoMTUjTBnuM1PR9yEbo+A3
         NUTfxef3gAYqTPP2Rzj2y33z2dhd4+4u8j7uYtmx+fkvcHpX4kucsG31xo9oaP+ulb4z
         4jlg==
X-Gm-Message-State: AOJu0YyJpa4yhPWSuRteAhfKyxee02N+f/rPi+164M9HWtlKr7Li8ASn
	1N1nHkXXY6TcCb38rJHg5OX1gHjx2YVa16D/phJqi4iCvEryYvOpIIWmu0zs+Q==
X-Gm-Gg: ASbGncuEoikqutKkrn6RL+/R/9vWslRK8H2pGZQ6GNCzMk9/cVyPWPtAdZWiSn3IqnY
	jOMO22heG1vIyvklqRdzcO6/ulpUX389j/xwUgiVC+UvWSn1l0D+GdT4YIqc6qTcrjGgvxO4J9d
	qbDkcAoYi4TQFnsdU9H3dlGRw95rFXcqheiFcZ/hE+59o6NXhfwtgFFPnnoDJ222AFqTk/svNxq
	MkXyc60+DkSiLIqqDKi+zrwvnlhLCzdvgsUAtYOf3HHnzJQJ6olO2bBPrwBqhmHGZX4pTngV3jL
	z1MHw0OfuJ/c+OKe6htOBSu14lJJZhrP2yW1w7bRcO427lOJ9dTYsGl2Yl2rcb0i9i6o3wmXMP5
	sGXADIar/VVl30DZnHtA=
X-Google-Smtp-Source: AGHT+IHr/h8LMAq4D6Xkb3rU4602VFMlDFz/n0CzfnHoJuGC8Nq2KZrbPHG1pdTWXy65B0JfSGCI+A==
X-Received: by 2002:a17:906:dc93:b0:b02:d867:b837 with SMTP id a640c23a62f3a-b0493084d31mr511388866b.7.1757103074299;
        Fri, 05 Sep 2025 13:11:14 -0700 (PDT)
Message-ID: <01d9ec74-27bb-4e41-9676-12ce028c503f@linux.com>
Date: Fri, 5 Sep 2025 23:11:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "kernel-hardening@lists.openwall.com"
 <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org,
 kasan-dev <kasan-dev@googlegroups.com>, Kees Cook <keescook@chromium.org>,
 Kees Cook <kees@kernel.org>, Jann Horn <jannh@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Matteo Rizzo <matteorizzo@google.com>, Florent Revest <revest@google.com>,
 GONG Ruiqi <gongruiqi1@huawei.com>, Harry Yoo <harry.yoo@oracle.com>,
 Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
From: Alexander Popov <alex.popov@linux.com>
Subject: Slab allocator hardening and cross-cache attacks
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello!

I published the article "Kernel-hack-drill and a new approach to exploiting 
CVE-2024-50264 in the Linux kernel":
https://a13xp0p0v.github.io/2025/09/02/kernel-hack-drill-and-CVE-2024-50264.html

It's about exploiting CVE-2024-50264, a race condition in AF_VSOCK sockets that 
happens between the connect() system call and a POSIX signal, resulting in a 
use-after-free (UAF).

I chose Ubuntu Server 24.04 with OEM/HWE kernel as the target for my 
experiments. This kernel ships with kconfig options that neutralize naive heap 
spraying for UAF exploitation:
  - CONFIG_SLAB_BUCKETS=y, which creates a set of separate slab caches for 
allocations with user-controlled data;
  - CONFIG_RANDOM_KMALLOC_CACHES=y, which creates multiple copies of slab caches 
for normal kmalloc allocation and makes kmalloc randomly pick one based on code 
address.

I used my pet project kernel-hack-drill to learn how cross-cache attacks behave 
on the kernel with slab allocator hardening turned on. Kernel-hack-drill is an 
open-source project (published under GPL-3.0) that provides a testing 
environment for learning and experimenting with Linux kernel vulnerabilities, 
exploit primitives, and kernel hardening features:
https://github.com/a13xp0p0v/kernel-hack-drill

In kernel-hack-drill, I developed several prototypes that implement cross-cache 
and cross-allocator attacks. The article thoroughly describes the procedure I 
used to debug them.

After experimenting with kernel-hack-drill on Ubuntu Server 24.04, I found that 
CONFIG_RANDOM_KMALLOC_CACHES and CONFIG_SLAB_BUCKETS block naive UAF 
exploitation, yet they also make my cross-cache attacks completely stable. It 
looks like these allocator features give an attacker better control over the 
slab with vulnerable objects and reduce the noise from other objects. Would you 
agree?

It seems that, without a mitigation such as SLAB_VIRTUAL, the Linux kernel 
remains wide-open to cross-cache attacks.

Best regards,
Alexander
