Return-Path: <SRS0=MJn0=ZH=lists.openwall.com=kernel-hardening-return-17374-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AFDC432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 07:44:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D6C720740
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 07:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FTkRFdQC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D6C720740
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17374-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27686 invoked by uid 550); 15 Nov 2019 07:44:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27649 invoked from network); 15 Nov 2019 07:44:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=X0VNfringVRO9ZVRht9e5s3LnUQ2e+qgyFMElJYlBIg=;
 b=FTkRFdQCWVcIB180H/MSBxHyx1lVnNNCof55N5Ov2f+txzz8Za5Gydrm+0xdStCJBxOP
 4TjQXY4sZnWI3iTduYZ/gS7Zy/ZBBd9tATAg/Uy7oQirEjzUefd+JqpmRRFB41YqVrCe
 LQp9zTlFSuluEESaLQn00M4vzqOU0lIBr2Db49ie8wCOyuPnLjkJNhlS1eTUufJuy2rU
 Qlm6xurzXjLkBeH1h/ew5b4+SxRCvaGTXNukltC7PqXNlzhDJ+N5TdAraVDnxuoWM/4S
 ZZ8KyhMn+T23ILPwLM4ad+xOAfvMIsd09iCtIjQ0eRmlohDr9ISKh33mgnNwdGHUzilO nA== 
Date: Fri, 15 Nov 2019 10:42:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl*: Remove tasklet callback casts
Message-ID: <20191115074235.GJ19079@kadam.lan>
References: <201911142135.5656E23@keescook>
 <20191115074003.GB19101@kadam.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115074003.GB19101@kadam.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150069

On Fri, Nov 15, 2019 at 10:40:03AM +0300, Dan Carpenter wrote:
> On Thu, Nov 14, 2019 at 09:39:00PM -0800, Kees Cook wrote:
> > In order to make the entire kernel usable under Clang's Control Flow
> > Integrity protections, function prototype casts need to be avoided
> > because this will trip CFI checks at runtime (i.e. a mismatch between
> > the caller's expected function prototype and the destination function's
> > prototype). Many of these cases can be found with -Wcast-function-type,
> > which found that the rtl wifi drivers had a bunch of needless function
> > casts. Remove function casts for tasklet callbacks in the various drivers.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Clang should treat void pointers as a special case.  If void pointers
> are bad, surely replacing them with unsigned long is even more ambigous
> and worse.

Wow...  Never mind.  I completely misread this patch.  I am ashamed.

The patch is fine.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

