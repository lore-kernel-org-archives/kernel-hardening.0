Date: Fri, 26 Oct 2018 09:05:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181026090518.6f3c064e@lwn.net>
In-Reply-To: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
	<20181023213504.28905-11-igor.stoppa@huawei.com>
	<20181026092609.GB3159@worktop.c.hoisthospitality.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 Oct 2018 11:26:09 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> Jon,
> 
> So the below document is a prime example for why I think RST sucks. As a
> text document readability is greatly diminished by all the markup
> nonsense.

Please don't confused RST with the uses of it.  The fact that one can do
amusing things with the C preprocessor doesn't, on its own, make C
suck... 
> 
> This stuff should not become write-only content like html and other
> gunk. The actual text file is still the primary means of reading this.

I agree that the text file comes first, and I agree that the markup in
this particular document is excessive.

Igor, just like #ifdef's make code hard to read, going overboard with RST
markup makes text hard to read.  It's a common trap to fall into, because
it lets you make slick-looking web pages, but that is not our primary
goal here.  Many thanks for writing documentation for this feature, that
already puts you way ahead of a discouraging number of contributors.  But
could I ask you, please, to make a pass over it and reduce the markup to
a minimum?  Using lists as suggested by Markus would help here.

Thanks,

jon
