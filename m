Date: Fri, 10 Feb 2017 11:23:59 +0100
From: Anisse Astier <anisse@astier.eu>
Message-ID: <20170210102359.GA30383@bifrost>
References: <20170210100902.11765-1-me@jessfraz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210100902.11765-1-me@jessfraz.com>
Subject: Re: [kernel-hardening] [PATCH 0/4] set {msi_domain,syscore}_ops as
 __ro_after_init
To: Jess Frazelle <me@jessfraz.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jess,

On Fri, Feb 10, 2017 at 02:08:58AM -0800, Jess Frazelle wrote:
> This is an initial pass and sanity check to make sure this is correct. The
> changes have all been tested on x86.

May I suggested for the next iteration that you Cc: the
maintainers/lists for each affected subsystem ?

Regards,

Anisse
