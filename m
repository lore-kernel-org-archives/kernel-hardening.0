From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 0/2] Add kvzalloc_struct to complement kvzalloc_array
Date: Wed, 14 Feb 2018 10:26:16 -0800
Message-Id: <20180214182618.14627-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

We all know the perils of multiplying a value provided from userspace
by a constant and then allocating the resulting number of bytes.  That's
why we have kvmalloc_array(), so we don't have to think about it.
This solves the same problem when we embed one of these arrays in a
struct like this:

struct {
	int n;
	unsigned long array[];
};

Using kvzalloc_struct() to allocate this will save precious thinking
time and reduce the possibilities of bugs.

Matthew Wilcox (2):
  mm: Add kernel-doc for kvfree
  mm: Add kvmalloc_ab_c and kvzalloc_struct

 include/linux/mm.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/util.c          | 10 ++++++++++
 2 files changed, 61 insertions(+)

-- 
2.15.1
