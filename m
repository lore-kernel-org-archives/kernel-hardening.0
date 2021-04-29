Return-Path: <SRS0=kJtc=J2=lists.openwall.com=kernel-hardening-return-21224-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBF2C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Apr 2021 14:05:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 279D76143A
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Apr 2021 14:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 279D76143A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21224-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23603 invoked by uid 550); 29 Apr 2021 14:05:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23566 invoked from network); 29 Apr 2021 14:05:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=XWujCC1T2A1mMi7XFh+vWKACrp/bu7LxNnRA3pYtwqg=;
 b=h953Gq0Vwb2epbVqoLOWxkGz+aWIeGGh7TYELDFR2oJBUfQYiX+prI5i5pAAK07O3BgG
 zuNASl0NBCIt0UMwga5KsqBIBI452h7Cr3NbtnQ83vhvjL1ofIvS5tuN5lA3liqLwaju
 6iLHG6tS9nh81rpd0WrFDpVelyyh+6UZ9cpXEONciLOPWzUahSrsQ+nlhE1nhJ3xEqw0
 saZHr52QqKS5sZVv2xkfrig5w7MRtcmvc3wuHNFbJVnf6grZI1xdZaYIXz3iWhAR9ZyD
 6gSzam9m8fC8jxTinaK6b+PV8bd6bxVGRC24Bkat4IU5/Nqizx66EvVTXqIMNGPhQnGX 5A== 
Date: Thu, 29 Apr 2021 17:04:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@lists.01.org, legion@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org
Cc: lkp@intel.com, kbuild-all@lists.01.org, Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH v11 4/9] Reimplement RLIMIT_NPROC on top of ucounts
Message-ID: <202104272256.9Y5ZQxrO-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5286a8aa16d2d698c222f7532f3d735c82bc6bc.1619094428.git.legion@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: GnOKWP_uxfwZW1upvqeIeMmTwjRK-LjD
X-Proofpoint-ORIG-GUID: GnOKWP_uxfwZW1upvqeIeMmTwjRK-LjD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9969 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290093

Hi,

url:    https://github.com/0day-ci/linux/commits/legion-kernel-org/Count-rlimits-in-each-user-namespace/20210427-162857
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
config: arc-randconfig-m031-20210426 (attached as .config)
compiler: arceb-elf-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
kernel/ucount.c:270 dec_rlimit_ucounts() error: uninitialized symbol 'new'.

vim +/new +270 kernel/ucount.c

176ec2b092cc22 Alexey Gladkov 2021-04-22  260  bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
176ec2b092cc22 Alexey Gladkov 2021-04-22  261  {
176ec2b092cc22 Alexey Gladkov 2021-04-22  262  	struct ucounts *iter;
176ec2b092cc22 Alexey Gladkov 2021-04-22  263  	long new;
                                                ^^^^^^^^

176ec2b092cc22 Alexey Gladkov 2021-04-22  264  	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
176ec2b092cc22 Alexey Gladkov 2021-04-22  265  		long dec = atomic_long_add_return(-v, &iter->ucount[type]);
176ec2b092cc22 Alexey Gladkov 2021-04-22  266  		WARN_ON_ONCE(dec < 0);
176ec2b092cc22 Alexey Gladkov 2021-04-22  267  		if (iter == ucounts)
176ec2b092cc22 Alexey Gladkov 2021-04-22  268  			new = dec;
176ec2b092cc22 Alexey Gladkov 2021-04-22  269  	}
176ec2b092cc22 Alexey Gladkov 2021-04-22 @270  	return (new == 0);
                                                        ^^^^^^^^
I don't know if this is a bug or not, but I can definitely tell why the
static checker complains about it.

176ec2b092cc22 Alexey Gladkov 2021-04-22  271  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

