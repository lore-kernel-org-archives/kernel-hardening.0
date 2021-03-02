Return-Path: <SRS0=tbhK=IA=lists.openwall.com=kernel-hardening-return-20869-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BC0C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Mar 2021 13:30:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A8F4E64EFC
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Mar 2021 13:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8F4E64EFC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20869-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30423 invoked by uid 550); 2 Mar 2021 13:30:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30387 invoked from network); 2 Mar 2021 13:30:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=o5Z9y33maAEhv+LN3/ehy6YtXs7A81xGJs4Xc3UM8Us=;
 b=VllA/SWXS8Sfpw7ry0WweQ6x2ljzTXD9dvJJsPlz0KSxXOSfY+Uho2M+xcWUKj0KbYcv
 Je18Btazt5UU0K7v4heRYP/YDmKTbEdyOOFa6TgZFSxCxG/uGMYs6AgQ5wBiTnOrnTSF
 A8vxDGAYnfPPusHCvTh5YBj0VGg0fXp/4ZumJ9ZfA/3R26tilmfxt0sJFGiOgE3Ck5NG
 D5G/UQGJjr0ozrBlHNiJ6h2k14U7Hf1Rjg9EcO9Eqquorm9m3v9KJrXJqEp3d6ljEzHP
 ofuw5Rpi5Royrs/OuxMsuB1fig89tQwCKN5N8tE9jmEb4PYDHIQSVPw6oF7kY1YdUqiz 7Q== 
Message-ID: <1a679c59345b02f10e425c8c5c55efd901dc714d.camel@linux.ibm.com>
Subject: Re: [PATCH 06/20] ima: Manual replacement of the deprecated
 strlcpy() with return values
From: Mimi Zohar <zohar@linux.ibm.com>
To: Romain Perier <romain.perier@gmail.com>,
        Kees Cook
 <keescook@chromium.org>,
        kernel-hardening@lists.openwall.com,
        Dmitry
 Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Mar 2021 08:29:58 -0500
In-Reply-To: <20210222151231.22572-7-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
	 <20210222151231.22572-7-romain.perier@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_06:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020107

On Mon, 2021-02-22 at 16:12 +0100, Romain Perier wrote:
> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.

As other's have pointed out, "lenght" -> length.

> It can lead to linear read overflows, crashes, etc...
> 
> As recommended in the deprecated interfaces [1], it should be replaced
> by strscpy.
> 
> This commit replaces all calls to strlcpy that handle the return values
> by the corresponding strscpy calls with new handling of the return
> values (as it is quite different between the two functions).
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  security/integrity/ima/ima_policy.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 9b45d064a87d..1a905b8b064f 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -790,8 +790,14 @@ static int __init ima_init_arch_policy(void)
>  	for (rules = arch_rules, i = 0; *rules != NULL; rules++) {
>  		char rule[255];
>  		int result;
> +		ssize_t len;
>  
> -		result = strlcpy(rule, *rules, sizeof(rule));
> +		len = strscpy(rule, *rules, sizeof(rule));
> +		if (len == -E2BIG) {
> +			pr_warn("Internal copy of architecture policy rule '%s' "
> +				"failed. Skipping.\n", *rules);

"arch_rules" is an array of hard coded strings.   The generic reason
for replacing strlcpy with strscpy doesn't seem applicable; however,
the additonal warning is appropriate.

(User-visible strings are not bound to the 80 column length.  Breaking
up the line like this is fine, but unnecessary.)

Acked-by: Mimi Zohar <zohar@linux.ibm.com>

thanks,

Mimi

> +			continue;
> +		}
>  
>  		INIT_LIST_HEAD(&arch_policy_entry[i].list);
>  		result = ima_parse_rule(rule, &arch_policy_entry[i]);
> 



