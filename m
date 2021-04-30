Return-Path: <SRS0=GZx+=J3=lists.openwall.com=kernel-hardening-return-21225-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B28FC433B4
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Apr 2021 18:10:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2730761468
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Apr 2021 18:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2730761468
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21225-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25755 invoked by uid 550); 30 Apr 2021 18:10:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25674 invoked from network); 30 Apr 2021 18:10:16 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@lists.01.org,  legion@kernel.org,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  lkp@intel.com,  kbuild-all@lists.01.org,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>
References: <202104272256.9Y5ZQxrO-lkp@intel.com>
Date: Fri, 30 Apr 2021 13:09:55 -0500
In-Reply-To: <202104272256.9Y5ZQxrO-lkp@intel.com> (Dan Carpenter's message of
	"Thu, 29 Apr 2021 17:04:23 +0300")
Message-ID: <m1tunny77w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcXaR-00085W-UW;;;mid=<m1tunny77w.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18u6Xoo8s58CoWsQdxvXXEoS28W8e953RU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH] ucounts: Silence warning in dec_rlimit_ucounts
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> url:    https://github.com/0day-ci/linux/commits/legion-kernel-org/Count-rlimits-in-each-user-namespace/20210427-162857
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
> config: arc-randconfig-m031-20210426 (attached as .config)
> compiler: arceb-elf-gcc (GCC) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> smatch warnings:
> kernel/ucount.c:270 dec_rlimit_ucounts() error: uninitialized symbol 'new'.
>
> vim +/new +270 kernel/ucount.c
>
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  260  bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  261  {
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  262   struct ucounts *iter;
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  263   long new;
>                                                 ^^^^^^^^
>
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  264   for (iter = ucounts; iter; iter = iter->ns->ucounts) {
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  265    long dec = atomic_long_add_return(-v, &iter->ucount[type]);
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  266    WARN_ON_ONCE(dec < 0);
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  267    if (iter == ucounts)
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  268     new = dec;
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  269   }
> 176ec2b092cc22 Alexey Gladkov 2021-04-22 @270   return (new == 0);
>                                                         ^^^^^^^^
> I don't know if this is a bug or not, but I can definitely tell why the
> static checker complains about it.
>
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  271  }

In the only two cases that care about the return value of
dec_rlimit_ucounts the code first tests to see that ucounts is not
NULL.  In those cases it is guaranteed at least one iteration of the
loop will execute guaranteeing the variable new will be initialized.

Initialize new to -1 so that the return value is well defined even
when the loop does not execute and the static checker is silenced.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ucount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index d316bac3e520..12a48457bb86 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -263,7 +263,7 @@ long inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
 {
 	struct ucounts *iter;
-	long new;
+	long new = -1; /* Silence compiler warnings */
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long dec = atomic_long_add_return(-v, &iter->ucount[type]);
 		WARN_ON_ONCE(dec < 0);
-- 
2.30.1

