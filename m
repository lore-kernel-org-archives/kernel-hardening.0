References: <20170210100902.11765-1-me@jessfraz.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <35d72812-2551-2615-d7fc-dde08ed62386@redhat.com>
Date: Fri, 10 Feb 2017 12:27:26 -0800
MIME-Version: 1.0
In-Reply-To: <20170210100902.11765-1-me@jessfraz.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 0/4] set {msi_domain,syscore}_ops as
 __ro_after_init
To: Jess Frazelle <me@jessfraz.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 02/10/2017 02:08 AM, Jess Frazelle wrote:
> This is an initial pass and sanity check to make sure this is correct. The
> changes have all been tested on x86.
> 
> Best,
> Jess
> 

Looks good to me. I also boot tested this on arm64 as well. I'll give
an actual Tested-by when you send the follow on series.

Thanks,
Laura
