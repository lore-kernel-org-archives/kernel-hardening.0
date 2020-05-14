Return-Path: <SRS0=vDpq=64=lists.openwall.com=kernel-hardening-return-18800-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F02C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 18:46:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B05EE20657
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 18:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B05EE20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18800-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13715 invoked by uid 550); 14 May 2020 18:46:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13683 invoked from network); 14 May 2020 18:46:24 -0000
Subject: Re: [PATCH v17 05/10] fs,landlock: Support filesystem access-control
To: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200511192156.1618284-1-mic@digikod.net>
 <20200511192156.1618284-6-mic@digikod.net>
 <alpine.LRH.2.21.2005141335280.30052@namei.org>
 <c159d845-6108-4b67-6527-405589fa5382@digikod.net>
 <bcfa8f74-5bc9-b363-5372-b254ba2e88a7@schaufler-ca.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <2d781760-341e-2f7a-9586-558fcf41a097@digikod.net>
Date: Thu, 14 May 2020 20:46:08 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <bcfa8f74-5bc9-b363-5372-b254ba2e88a7@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 14/05/2020 17:58, Casey Schaufler wrote:
> On 5/14/2020 3:39 AM, Mickaël Salaün wrote:
>> On 14/05/2020 05:37, James Morris wrote:
>>> On Mon, 11 May 2020, Mickaël Salaün wrote:
>>>
>>>
>>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>>> index 45cc10cdf6dd..2276642f8e05 100644
>>>> --- a/include/linux/fs.h
>>>> +++ b/include/linux/fs.h
>>>> @@ -1517,6 +1517,11 @@ struct super_block {
>>>>  	/* Pending fsnotify inode refs */
>>>>  	atomic_long_t s_fsnotify_inode_refs;
>>>>  
>>>> +#ifdef CONFIG_SECURITY_LANDLOCK
>>>> +	/* References to Landlock underlying objects */
>>>> +	atomic_long_t s_landlock_inode_refs;
>>>> +#endif
>>>> +
>>> This needs to be converted to the LSM API via superblock blob stacking.
>>>
>>> See Casey's old patch: 
>>> https://lore.kernel.org/linux-security-module/20190829232935.7099-2-casey@schaufler-ca.com/
>> s_landlock_inode_refs is quite similar to s_fsnotify_inode_refs, but I
>> can do it once the superblock security blob patch is upstream. Is it a
>> blocker for now? What is the current status of lbs_superblock?
> 
> As no currently stackable modules conflict over the superblock
> (SELinux and Smack are the existing users) there has been no need
> to move its management into the infrastructure. The active push for
> stacking does not (yet) include everything needed for SELinux+Smack.
> It includes what is needed for SELinux+AppArmor and Smack+AppArmor.
> That does not include the superblock blob.
> 
> You can include a patch in the landlock set that provides infrastructure
> management of the superblock blob. Feel free to glean it from my proposal.

OK, I'll add it to the next series.
