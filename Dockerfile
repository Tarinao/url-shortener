# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# ✅ Copy ALL application source code
COPY . .

# Copy student_id.txt (already included above but keep for clarity)
COPY student_id.txt ./

# Read student ID from file
RUN STUDENT_ID=$(cat student_id.txt) && \
    echo "export STUDENT_ID='$STUDENT_ID'" >> /etc/profile

# Accept BUILD_TIME as build argument
ARG BUILD_TIME

# Handle build time
RUN if [ -z "$BUILD_TIME" ]; then \
      BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ"); \
    fi && \
    echo "$BUILD_TIME" > /app/build_time.txt && \
    echo "Build Time: $BUILD_TIME"

# Save build time to ENV
RUN BUILD_TIME=$(cat /app/build_time.txt) && \
    echo "export BUILD_TIME='$BUILD_TIME'" >> /etc/profile

ENV STUDENT_ID_FILE=/app/student_id.txt
ENV BUILD_TIME_FILE=/app/build_time.txt

# Display build info
RUN if [ -f student_id.txt ]; then echo "Student ID: $(cat student_id.txt)"; fi && \
    if [ -f build_time.txt ]; then echo "Build Time: $(cat build_time.txt)"; fi

# Expose port
EXPOSE 3000

# Set environment to production
ENV NODE_ENV=production

# ✅ Start the application
CMD ["npm", "start"]