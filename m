Date: Thu, 25 Oct 2018 10:03:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v1 PATCH 00/17] prmem: protected memory
Message-ID: <20181024230345.GE6311@dastard>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 24, 2018 at 12:34:47AM +0300, Igor Stoppa wrote:
> -- Summary --
> 
> Preliminary version of memory protection patchset, including a sample use
> case, turning into write-rare the IMA measurement list.

I haven't looked at the patches yet, but I see a significant issue
from the subject lines. "prmem" is very similar to "pmem"
(persistent memory) and that's going to cause confusion. Especially
if people start talking about prmem and pmem in the context of write
protect pmem with prmem...

Naming is hard :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
