Return-Path: <SRS0=PrmF=XU=lists.openwall.com=kernel-hardening-return-16936-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B3FC432C2
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Sep 2019 22:03:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F058820673
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Sep 2019 22:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F058820673
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16936-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25942 invoked by uid 550); 25 Sep 2019 22:03:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25924 invoked from network); 25 Sep 2019 22:03:03 -0000
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="gz'50?scan'50,208,50";a="389381145"
Date: Thu, 26 Sep 2019 06:02:11 +0800
From: kbuild test robot <lkp@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: kbuild-all@01.org, Paul Moore <paul@paul-moore.com>,
	linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?J=E9r=E9mie?= Galarneau <jeremie.galarneau@efficios.com>,
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk,
	dan.carpenter@oracle.com, akpm@linux-foundation.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH] audit: Report suspicious O_CREAT usage
Message-ID: <201909260509.Ilv7TH89%lkp@intel.com>
References: <201909251348.A1542A52@keescook>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jxm6am24gmzrkwwr"
Content-Disposition: inline
In-Reply-To: <201909251348.A1542A52@keescook>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)


--jxm6am24gmzrkwwr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.3 next-20190924]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Kees-Cook/audit-Report-suspicious-O_CREAT-usage/20190926-050423
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-13) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/fsnotify.h:16:0,
                    from fs/namei.c:25:
   include/linux/audit.h:222:1: error: expected identifier or '(' before '{' token
    { }
    ^
   In file included from include/linux/fsnotify.h:16:0,
                    from fs/namei.c:25:
>> include/linux/audit.h:221:20: warning: 'audit_log_path_denied' used but never defined
    static inline void audit_log_path_denied(int type, const char *string);
                       ^~~~~~~~~~~~~~~~~~~~~

vim +/audit_log_path_denied +221 include/linux/audit.h

   187	
   188	#else /* CONFIG_AUDIT */
   189	static inline __printf(4, 5)
   190	void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
   191		       const char *fmt, ...)
   192	{ }
   193	static inline struct audit_buffer *audit_log_start(struct audit_context *ctx,
   194							   gfp_t gfp_mask, int type)
   195	{
   196		return NULL;
   197	}
   198	static inline __printf(2, 3)
   199	void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
   200	{ }
   201	static inline void audit_log_end(struct audit_buffer *ab)
   202	{ }
   203	static inline void audit_log_n_hex(struct audit_buffer *ab,
   204					   const unsigned char *buf, size_t len)
   205	{ }
   206	static inline void audit_log_n_string(struct audit_buffer *ab,
   207					      const char *buf, size_t n)
   208	{ }
   209	static inline void  audit_log_n_untrustedstring(struct audit_buffer *ab,
   210							const char *string, size_t n)
   211	{ }
   212	static inline void audit_log_untrustedstring(struct audit_buffer *ab,
   213						     const char *string)
   214	{ }
   215	static inline void audit_log_d_path(struct audit_buffer *ab,
   216					    const char *prefix,
   217					    const struct path *path)
   218	{ }
   219	static inline void audit_log_key(struct audit_buffer *ab, char *key)
   220	{ }
 > 221	static inline void audit_log_path_denied(int type, const char *string);
 > 222	{ }
   223	static inline int audit_log_task_context(struct audit_buffer *ab)
   224	{
   225		return 0;
   226	}
   227	static inline void audit_log_task_info(struct audit_buffer *ab)
   228	{ }
   229	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jxm6am24gmzrkwwr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
CKKWZ+gIOp4efyc4UPgXl2jGeRtoAAA=

--jxm6am24gmzrkwwr--
