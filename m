Date: Tue, 27 Mar 2018 10:55:09 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH v21 0/6] mm: security: ro protection for dynamic
 data
Message-ID: <20180327105509.62ec0d4d@lwn.net>
In-Reply-To: <20180327153742.17328-1-igor.stoppa@huawei.com>
References: <20180327153742.17328-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: willy@infradead.org, keescook@chromium.org, mhocko@kernel.org, david@fromorbit.com, rppt@linux.vnet.ibm.com, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, igor.stoppa@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Mar 2018 18:37:36 +0300
Igor Stoppa <igor.stoppa@huawei.com> wrote:

> This patch-set introduces the possibility of protecting memory that has
> been allocated dynamically.

One thing that jumps out at me as I look at the patch set is: you do not
include any users of this functionality.  Where do you expect this
allocator to be used?  Actually seeing the API in action would be a useful
addition, I think.

Thanks,

jon
