Date: Sun, 11 Feb 2018 13:17:41 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 6/6] Documentation for Pmalloc
Message-ID: <20180211211741.GD4680@bombadil.infradead.org>
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-7-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180211031920.3424-7-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 11, 2018 at 05:19:20AM +0200, Igor Stoppa wrote:
> @@ -0,0 +1,114 @@
> +SPDX-License-Identifier: CC-BY-SA-4.0

You need the '.. ' before the 'SPDX'.  See
Documentation/process/license-rules.rst
