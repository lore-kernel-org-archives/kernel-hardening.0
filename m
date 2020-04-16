Return-Path: <SRS0=wNv8=6A=lists.openwall.com=kernel-hardening-return-18513-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B151C2BA19
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 00:15:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 06FD72078B
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 00:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06FD72078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18513-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14037 invoked by uid 550); 16 Apr 2020 00:15:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14017 invoked from network); 16 Apr 2020 00:15:20 -0000
IronPort-SDR: FZo4fsWO69p9PUj/3nrVpZteUJz0RyzE3QUn24I10r4SejTLQ17ziht9GEbcrLZ6D3nfM/oBbi
 Ln0b+3qmyLAA==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
IronPort-SDR: 3rVFVDeGcNl6HtVcgLd4GMykj2Wf9o9VapmUD7r25jT4ac/rP8ZeBiUigUmTqE3rjlssuzILxu
 ZO0SQ20jEDiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="gz'50?scan'50,208,50";a="274914925"
Date: Thu, 16 Apr 2020 08:14:09 +0800
From: kbuild test robot <lkp@intel.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>,
	keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: kbuild-all@lists.01.org, arjan@linux.intel.com,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	rick.p.edgecomb@intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 7/9] x86: Add support for function granular KASLR
Message-ID: <202004160811.sBWd3bTo%lkp@intel.com>
References: <20200415210452.27436-8-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20200415210452.27436-8-kristen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kristen,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kees/for-next/pstore]
[also build test ERROR on tip/auto-latest linus/master tip/x86/core v5.7-rc1 next-20200415]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Kristen-Carlson-Accardi/Function-Granular-Kernel-Address-Space-Layout-Randomization/20200416-072741
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/pstore
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: arch/x86/boot/compressed/misc.o: in function `index_update.isra.12':
>> misc.c:(.text+0x102c): undefined reference to `xz_crc32_table'
   ld: arch/x86/boot/compressed/misc.o: in function `xz_crc32_init':
   misc.c:(.text+0x11c0): undefined reference to `xz_crc32_table'
   ld: arch/x86/boot/compressed/misc.o: in function `xz_crc32':
   misc.c:(.text+0x1213): undefined reference to `xz_crc32_table'
   ld: arch/x86/boot/compressed/misc.o: in function `xz_dec_run':
   misc.c:(.text+0x1e69): undefined reference to `xz_crc32_table'
>> ld: misc.c:(.text+0x1f2d): undefined reference to `xz_crc32_table'
   ld: arch/x86/boot/compressed/misc.o:misc.c:(.text+0x1ff3): more undefined references to `xz_crc32_table' follow

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--2oS5YaxWCcQjTEyO
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ilqbT2RoAAA=

--2oS5YaxWCcQjTEyO--
