From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 0/2] Update stackleak for gcc-8
Date: Thu, 22 Feb 2018 15:14:40 -0800
Message-Id: <20180222231442.29507-1-labbott@redhat.com>
In-Reply-To: <22f5c157-8b01-5e0a-69e1-44939cc73d7e@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>


Okay I _think_ this should be the solution for gcc-8. I've split this
into two patches, one for the generic framework and the other for the
stackleak plugin itself. Kees, I'll let you figure out how to apply
these. Feel free to fold in as appropriate.



Laura Abbott (2):
  gcc-plugins: Update cgraph_create_edge for gcc-8
  gcc-plugins: stackleak: Update for gcc-8

 scripts/gcc-plugins/gcc-common.h       |  6 ++++++
 scripts/gcc-plugins/stackleak_plugin.c | 24 +++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

-- 
2.14.3
