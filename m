Reply-To: kernel-hardening@lists.openwall.com
From: william.c.roberts@intel.com
Date: Tue, 26 Jul 2016 11:22:25 -0700
Message-Id: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] [PATCH] [RFC] Introduce mmap randomization
To: jason@lakedaemon.net, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, akpm@linux-foundation.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, nnk@google.com, jeffv@google.com, salyzyn@android.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>

The recent get_random_long() change in get_random_range() and then the
subsequent patches Jason put out, all stemmed from my tinkering
with the concept of randomizing mmap.

Any feedback would be greatly appreciated, including any feedback
indicating that I am idiot.
