Return-Path: <SRS0=TtfZ=U6=lists.openwall.com=kernel-hardening-return-16332-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4120FC0650E
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:47:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 75FD521721
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75FD521721
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16332-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18107 invoked by uid 550); 1 Jul 2019 18:47:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18086 invoked from network); 1 Jul 2019 18:47:26 -0000
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="gz'50?scan'50,208,50";a="184307028"
Date: Tue, 2 Jul 2019 02:46:37 +0800
From: kbuild test robot <lkp@intel.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	mathieu.desnoyers@efficios.com, willy@infradead.org,
	peterz@infradead.org, will.deacon@arm.com,
	paulmck@linux.vnet.ibm.com, elena.reshetova@intel.com,
	keescook@chromium.org, kernel-team@android.com,
	kernel-hardening@lists.openwall.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2] Convert struct pid count to refcount_t
Message-ID: <201907020214.bB70pmmk%lkp@intel.com>
References: <20190628193442.94745-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20190628193442.94745-1-joel@joelfernandes.org>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi "Joel,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.2-rc6]
[cannot apply to next-20190625]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Joel-Fernandes-Google/Convert-struct-pid-count-to-refcount_t/20190702-003517
config: riscv-allnoconfig (attached as .config)
compiler: riscv64-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=riscv 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/pid.c:44:30: warning: missing braces around initializer [-Wmissing-braces]
    struct pid init_struct_pid = {
                                 ^
>> kernel/pid.c:44:30: warning: missing braces around initializer [-Wmissing-braces]
>> kernel/pid.c:44:30: warning: missing braces around initializer [-Wmissing-braces]
>> kernel/pid.c:44:30: warning: missing braces around initializer [-Wmissing-braces]
>> kernel/pid.c:44:30: warning: missing braces around initializer [-Wmissing-braces]

vim +44 kernel/pid.c

^1da177e Linus Torvalds 2005-04-16  43  
e1e871af David Howells  2018-01-02 @44  struct pid init_struct_pid = {
e1e871af David Howells  2018-01-02  45  	.count 		= ATOMIC_INIT(1),
e1e871af David Howells  2018-01-02  46  	.tasks		= {
e1e871af David Howells  2018-01-02  47  		{ .first = NULL },
e1e871af David Howells  2018-01-02  48  		{ .first = NULL },
e1e871af David Howells  2018-01-02  49  		{ .first = NULL },
e1e871af David Howells  2018-01-02  50  	},
e1e871af David Howells  2018-01-02  51  	.level		= 0,
e1e871af David Howells  2018-01-02  52  	.numbers	= { {
e1e871af David Howells  2018-01-02  53  		.nr		= 0,
e1e871af David Howells  2018-01-02  54  		.ns		= &init_pid_ns,
e1e871af David Howells  2018-01-02  55  	}, }
e1e871af David Howells  2018-01-02  56  };
^1da177e Linus Torvalds 2005-04-16  57  

:::::: The code at line 44 was first introduced by commit
:::::: e1e871aff3ded26348c631b1370e257d401cd22d Expand INIT_STRUCT_PID and remove

:::::: TO: David Howells <dhowells@redhat.com>
:::::: CC: David Howells <dhowells@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--yrj/dFKFPuw6o+aM
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--yrj/dFKFPuw6o+aM--
